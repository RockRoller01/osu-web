# Copyright (c) ppy Pty Ltd <contact@ppy.sh>. Licensed under the GNU Affero General Public License v3.0.
# See the LICENCE file in the repository root for full licence text.

import BbcodeEditor from 'bbcode-editor'
import { Modal } from 'modal'
import * as React from 'react'
import { a, button, div, h3, span, i, textarea } from 'react-dom-factories'
import MetadataEditor from 'beatmapsets-show/metadata-editor'
el = React.createElement

export class Info extends React.Component
  constructor: (props) ->
    super props

    @overlayRef = React.createRef()
    @chartAreaRef = React.createRef()

    @state =
      isBusy: false
      isEditingDescription: false
      isEditingMetadata: false


  componentDidMount: ->
    @renderChart()


  componentDidUpdate: ->
    @renderChart()


  componentWillUnmount: =>
    $(window).off '.beatmapsetPageInfo'


  # see Modal#hideModal
  dismissEditor: (e) =>
    @setState isEditingDescription: false if e.button == 0 &&
                                  e.target == @overlayRef.current &&
                                  @clickEndTarget == @clickStartTarget


  editStart: =>
    @setState isEditingDescription: true


  handleClickEnd: (e) =>
    @clickEndTarget = e.target


  handleClickStart: (e) =>
    @clickStartTarget = e.target


  onEditorChange: (action) =>
    switch action.type
      when 'save'
        if action.hasChanged
          @saveDescription(action.value)
        else
          @setState isEditingDescription: false

      when 'cancel'
        @setState isEditingDescription: false


  onSelectionUpdate: (selection) =>
    @setState selection: selection


  saveDescription: (value) =>
    @setState isBusy: true
    $.ajax laroute.route('beatmapsets.update', beatmapset: @props.beatmapset.id),
      method: 'PATCH',
      data:
        description: value

    .done (data) =>
      @setState
        isEditingDescription: false
        description: data.description

    .fail osu.ajaxError

    .always =>
      @setState isBusy: false


  toggleEditingMetadata: =>
    @setState isEditingMetadata: !@state.isEditingMetadata


  withEdit: =>
     @props.beatmapset.description.bbcode?


  withEditMetadata: =>
     @props.beatmapset.current_user_attributes?.can_edit_metadata ? false


  renderChart: ->
    return if !@props.beatmapset.is_scoreable || @props.beatmap.playcount < 1

    unless @_failurePointsChart?
      options =
        scales:
          x: d3.scaleLinear()
          y: d3.scaleLinear()
        modifiers: ['beatmap-success-rate']

      @_failurePointsChart = new StackedBarChart @chartAreaRef.current, options
      $(window).on 'throttled-resize.beatmapsetPageInfo', @_failurePointsChart.resize

    @_failurePointsChart.loadData @props.beatmap.failtimes


  renderEditMetadataButton: =>
    div className: 'beatmapset-info__edit-button',
      button
        type: 'button'
        className: 'btn-circle'
        onClick: @toggleEditingMetadata
        span className: 'btn-circle__content',
          i className: 'fas fa-pencil-alt'


  renderEditButton: =>
    div className: 'beatmapset-info__edit-button',
      button
        type: 'button'
        className: 'btn-circle'
        onClick: @editStart
        span className: 'btn-circle__content',
          i className: 'fas fa-pencil-alt'


  render: ->
    tags = _(@props.beatmapset.tags)
      .split(' ')
      .filter((t) -> t? && t != '')
      .slice(0, 21)
      .value()

    if tags.length == 21
      tags.pop()
      tagsOverload = true

    div className: 'beatmapset-info',
      if @state.isEditingDescription
        div className: 'beatmapset-description-editor',
          div
            className: 'beatmapset-description-editor__overlay'
            onClick: @dismissEditor
            onMouseDown: @handleClickStart
            onMouseUp: @handleClickEnd
            ref: @overlayRef

            div className: 'osu-page',
              el BbcodeEditor,
                modifiers: ['beatmapset-description-editor']
                disabled: @state.isBusy
                onChange: @onEditorChange
                onSelectionUpdate: @onSelectionUpdate
                rawValue: @state.description?.bbcode ? @props.beatmapset.description.bbcode
                selection: @state.selection

      if @state.isEditingMetadata
        el Modal, visible: true, onClose: @toggleEditingMetadata,
          el MetadataEditor, onClose: @toggleEditingMetadata, beatmapset: @props.beatmapset

      div className: 'beatmapset-info__box beatmapset-info__box--description',
        @renderEditButton() if @withEdit()

        h3
          className: 'beatmapset-info__header'
          osu.trans 'beatmapsets.show.info.description'

        div className: 'beatmapset-info__description-container u-fancy-scrollbar',
          div
            className: 'beatmapset-info__description'
            dangerouslySetInnerHTML:
              __html: @state.description?.description ? @props.beatmapset.description.description

      div className: 'beatmapset-info__box beatmapset-info__box--meta',
        @renderEditMetadataButton() if @withEditMetadata()

        if @props.beatmapset.source
          div null,
            h3
              className: 'beatmapset-info__header'
              osu.trans 'beatmapsets.show.info.source'

            a
              href: laroute.route('beatmapsets.index', q: @props.beatmapset.source)
              @props.beatmapset.source

        div className: 'beatmapset-info__half-box',
          div className: 'beatmapset-info__half-entry',
            h3 className: 'beatmapset-info__header',
              osu.trans 'beatmapsets.show.info.genre'
            a
              href: laroute.route('beatmapsets.index', g: @props.beatmapset.genre.id)
              @props.beatmapset.genre.name

          div className: 'beatmapset-info__half-entry',
            h3 className: 'beatmapset-info__header',
              osu.trans 'beatmapsets.show.info.language'
            a
              href: laroute.route('beatmapsets.index', l: @props.beatmapset.language.id)
              @props.beatmapset.language.name

        if tags.length > 0
          div null,
            h3
              className: 'beatmapset-info__header'
              osu.trans 'beatmapsets.show.info.tags'

            div null,
              for tag in tags
                [
                  a
                    key: tag
                    href: laroute.route('beatmapsets.index', q: tag)
                    tag
                  span key: "#{tag}-space", ' '
                ]
              '...' if tagsOverload

      div className: 'beatmapset-info__box beatmapset-info__box--success-rate',
        if !@props.beatmapset.is_scoreable
          div className: 'beatmap-success-rate',
            div
              className: 'beatmap-success-rate__empty'
              osu.trans 'beatmapsets.show.info.unranked'
        else
          if @props.beatmap.playcount > 0
            percentage = _.round((@props.beatmap.passcount / @props.beatmap.playcount) * 100, 1)
            div className: 'beatmap-success-rate',
              h3
                className: 'beatmap-success-rate__header'
                osu.trans 'beatmapsets.show.info.success-rate'

              div className: 'bar bar--beatmap-success-rate',
                div
                  className: 'bar__fill'
                  style:
                    width: "#{percentage}%"

              div
                className: 'beatmap-success-rate__percentage'
                title: "#{osu.formatNumber(@props.beatmap.passcount)} / #{osu.formatNumber(@props.beatmap.playcount)}"
                'data-tooltip-position': 'bottom center'
                style:
                  marginLeft: "#{percentage}%"
                "#{percentage}%"

              h3
                className: 'beatmap-success-rate__header'
                osu.trans 'beatmapsets.show.info.points-of-failure'

              div
                className: 'beatmap-success-rate__chart'
                ref: @chartAreaRef
          else
            div className: 'beatmap-success-rate',
              div
                className: 'beatmap-success-rate__empty'
                osu.trans 'beatmapsets.show.info.no_scores'

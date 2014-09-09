class RailsAdminSelectize
  constructor: (@$el) ->
    @single = false
    @el = @$el[0]

    @preload = @$el.data('preload')
    creatable = @$el.data('creatable')
    addTranslation = @$el.data('add-translation')

    @$el.val('')

    @$el.selectize(
      load: $.proxy(@search, this)
      preload: if @preload then 'focus' else false
      sortField: 'text'
      plugins: ['remove_button']
      create: creatable
      render:
        option_create: (data) ->
          """
            <div class="create" data-selectable="">
              #{ addTranslation } <strong>#{ data.input }</strong>...
            </div>
          """
    )

    if (value = @$el.data('value'))
      @initializeValue(value)

  search: (query, callback) ->
    return callback() unless query.length or @preload

    @preload = false if @preload

    console.log('SEARCH')

    $.ajax
      url: @$el.data('search-url')
      type: 'GET'
      data: @dataFor(query)
      error: callback
      success: @processResults(callback)

  processResults: (callback) ->
    (response) =>
      callback(response)

  dataFor: (query) ->
    searchParam = @$el.data('search-param')
    encodedQuery = encodeURIComponent(query)

    data = {}
    data[searchParam] = encodedQuery
    data

  initializeValue: (data) ->
    if @single
      @el.selectize.addOption(data)
    else
      $.each data, (i, item) => @el.selectize.addOption(item)

    if @single
      @el.selectize.addItem(data.value)
    else
      $.each data, (i, item) => @el.selectize.addItem(item.value)

  addAndSelect: (data) ->
    item = { text: data.label, value: data.id }
    @el.selectize.addOption(item)
    @el.selectize.addItem(item.value)


$(document).on "rails_admin.dom_ready", (e, content) ->
  $selectizes = $('[data-selectize]')

  return unless $selectizes.length

  if content
    return unless ($content = $(content)).is('form')

    if ($link = $("[data-link='#{ $content.attr('action') }?modal=true']"))
      $select = $link.closest('.controls').find('[data-selectize]')
      if (selectize = $select.data('rails_admin_selectize'))
        console.log "ajax success form", $content, selectize
        $content.on 'ajax:complete', (xhr, data, status) ->
          return if status is 'error'
          selectize.addAndSelect($.parseJSON(data.responseText))

  else
    $('[data-selectize]').each (i, el) ->
      $select = $(el)

      return if $select.data('rails_admin_selectize')

      instance = new RailsAdminSelectize($select)
      $select.data('rails_admin_selectize', instance)

      # hide link if we already are inside a dialog
      if $(this).parents("#modal").length
        $(this).parents('.controls').find('.btn').remove()
      else
        $(this).parents('.controls').first().remoteForm()


class RailsAdminSelectize
  constructor: (@$el) ->
    @single = false
    @el = @$el[0]

    @preload = @$el.data('preload')

    @$el.val('')

    console.log('load selectize', @$el.is('[data-preload]'))

    @$el.selectize(
      load: $.proxy(@search, this)
      preload: if @preload then 'focus' else false
      sortField: 'text'
      plugins: ['remove_button']
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


$(document).on "rails_admin.dom_ready", ->
  $('[data-selectize]').each (i, el) -> new RailsAdminSelectize($(el))

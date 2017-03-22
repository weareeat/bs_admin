$ ->
  $('.btn-bulk-destroy').click () ->
    $checked = $('.check:checked')
    url = $('.btn-bulk-destroy').data('url')
    data = $checked.map ->
      $(this).val()
    data = data.get()

    if data.length > 0
      $.post url, { assets: data }, ->
        window.location = window.location

  $('.btn-bulk-check').click () ->
    $('.btn-bulk-check').hide()
    $('.btn-bulk-uncheck').show()
    $('.check').prop('checked', true)

  $('.btn-bulk-uncheck').click () ->
    $('.btn-bulk-check').show()
    $('.btn-bulk-uncheck').hide()
    $('.check').prop('checked', false)

  $("a[rel=popover]").popover()
  $(".tooltip").tooltip()
  $("a[rel=tooltip]").tooltip()

  $("input.datetimepicker, .input-group.datetimepicker").each ->
    $(this).datetimepicker()

  $("input.datepicker, .input-group.datepicker").each ->
    $(this).datetimepicker pickTime: false

  $body = $("body")
  $(document).on
    ajaxStart: ->
      $body.addClass "loading"

    ajaxStop: ->
      $body.removeClass "loading"

  $(".permalink").each ->
    update = ->
      $(this).val $(this).val().replace(RegExp(" ", "g"), "")
      content = "your link will be <b>/" + $(this).val() + "</b>"
      $(this).parent().parent().children(".permalink-help-block").html content

    $(this).keydown update
    $(this).change update
    $(this).change()

  $(".submit").change ->
    @form.submit()

  $(".sortable").each ->
    $(this).sortable
      axis: "y"
      dropOnEmpty: false
      handle: ".drag"
      cursor: "crosshair"
      items: "tr"
      opacity: 0.4
      scroll: true
      update: ->
        $this = $(this)
        $.ajax
          type: "post"
          data: $this.sortable("serialize")
          dataType: "script"
          url: $this.attr("data-url")

  $('.select2').select2();

  exportToExcel = (htmls) ->
    htmls = ''
    uri = 'data:application/vnd.ms-excel;base64,'
    template = '<html xmlns:o="urn:schemas-microsoft-com:office:office" xmlns:x="urn:schemas-microsoft-com:office:excel" xmlns="http://www.w3.org/TR/REC-html40"><head><!--[if gte mso 9]><xml><x:ExcelWorkbook><x:ExcelWorksheets><x:ExcelWorksheet><x:Name>{worksheet}</x:Name><x:WorksheetOptions><x:DisplayGridlines/></x:WorksheetOptions></x:ExcelWorksheet></x:ExcelWorksheets></x:ExcelWorkbook></xml><![endif]--></head><body><table>{table}</table></body></html>'

    base64 = (s) ->
      window.btoa unescape(encodeURIComponent(s))

    format = (s, c) ->
      s.replace /{(\w+)}/g, (m, p) ->
        c[p]

    ctx =
      worksheet: 'Worksheet'
      table: htmls
    link = document.createElement('a')
    link.download = 'export.xls'
    link.href = uri + base64(format(template, ctx))
    link.click()
    return

  $('#meta-export').click (e) ->
    e.preventDefault()
    filters = ''
    if ($('.filters form').size())
      filters = $('.filters form').serialize()

    $.ajax({
      url: window.location.href + '/export?' + filters,
      success: (r) ->
        table = $(r)
        table.find('td > a').each ->
          $(this).closest('td').text(window.location.protocol + '//' + window.location.host + $(this).attr('href'))

        table.table2excel({
          name: $('h1').text().trim(),
          filename: "Export_" + $('h1').text().trim() + " " + ((new Date()) * 1)
        });
    })

  if $('.col-md-8.header-buttons .btn-bulk-destroy').size() == 0
    $('.select.check').each ->
      $(this).closest('td').remove()
      return

  $('.paginator.btn-group').each ->
    if ($(this).find('[rel="next"]').size() == 0)
      $(this).html($($(this).text()))
    return

  # $('.select2-tags').select2({ tags: true });

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
  # $('.select2-tags').select2({ tags: true });

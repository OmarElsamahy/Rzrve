//= require arctic_admin/base
//= require active_admin/searchable_select
//= require activeadmin_addons/all
//= require activeadmin/dynamic_fields

$(document).ready(function () {
    $(document).on("change", "select.type-dropdown", function () {
        let dropdown_value = $(this).val()
        const urlParams = new URLSearchParams(window.location.search);
        urlParams.set('country_id', dropdown_value);
    })

    $(document).on('select2:open', () => {
        document.querySelector('.select2-search__field').focus();
    });
})

console.log("hun");

$(document).ready(function () {
  $('input[name="daterange"]').on("focus", function () {
    $(this).daterangepicker({
      autoApply: true,
      locale: {
        format: "DD.MM.YY",
        firstDay: 1,
        daysOfWeek: ["Вс", "Пн", "Вт", "Ср", "Чт", "Пт", "Сб"],
        monthNames: [
          "Январь",
          "Февраль",
          "Март",
          "Апрель",
          "Май",
          "Июнь",
          "Июль",
          "Август",
          "Сентябрь",
          "Октябрь",
          "Ноябрь",
          "Декабрь",
        ],
      },
    });
  });
});

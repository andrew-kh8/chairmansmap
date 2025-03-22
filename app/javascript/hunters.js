console.log("hun");

var hunts = [
  {
    date: "21.01.25",
    time: "14:12",
    fio: "qwe",
    dog: false,
    weapon: false,
    description: "111111111",
  },
  {
    date: "16.01.25",
    time: "14:12",
    fio: "qwe",
    dog: false,
    weapon: false,
    description: "22",
  },
  {
    date: "12.01.25",
    time: "14:12",
    fio: "qwe",
    dog: false,
    weapon: false,
    description: "3333333333333",
  },
  {
    date: "25.01.25",
    time: "14:12",
    fio: "qwe",
    dog: false,
    weapon: false,
    description: "44444",
  },
];

$(document).ready(function () {
    hunts.forEach((element) => {
      $("#hunter_data").append(`
            <li class="p-1 my-1 bg-gray-50 shadow-2xl">
                <div class="flex items-center space-x-4">
                    <div class="flex-1 min-w-0">
                        <p class="text-base font-medium text-gray-900 truncate dark:text-white">
                            ${element.date} ${element.time}
                        </p>
                        <p class="text-sm text-gray-500 truncate dark:text-gray-400">
                            ${element.dog ? element.dog : "без собаки"}, ${element.weapon ? element.weapon : "без оружия"}
                        </p>
                    </div>
                    <div class="inline-flex items-center text-base font-semibold text-gray-900 dark:text-white">
                        ${element.time}
                    </div>
                </div>
            </li>
        `);
    });
    
});


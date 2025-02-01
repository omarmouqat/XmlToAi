const ml_script = document.getElementById("ml_script");
const train_data = document.getElementById("train_data");

const ml_script_label = document.getElementById("ml_script_label");
const train_data_label = document.getElementById("train_data_label");

const ml_script_content_for_training = document.getElementById("ml_script_content_for_training");
const train_data_content_for_training = document.getElementById("train_data_content_for_training");

ml_script.addEventListener("change", function (event) {
  const ml_script_file = event.target.files[0];
  if (ml_script_file) {
    const reader = new FileReader();
    reader.onload = function (e) {
      ml_script_content_for_training.innerHTML = e.target.result; // File content as text
      console.log(ml_script_content_for_training.innerHTML);
    };
    reader.readAsText(ml_script_file);
  }
});

train_data.addEventListener("change", function (event) {
  const train_data_file = event.target.files[0];
  if (train_data_file) {
    const reader = new FileReader();
    reader.onload = function (e) {
      train_data_content_for_training.innerHTML = e.target.result; // File content as text
      console.log(train_data_content_for_training.innerHTML);
    };
    reader.readAsText(train_data_file);
  }
});


ml_script.addEventListener("change", function (event) {
  const file = event.target.files[0];
  if (file) {
    ml_script_label.textContent = file.name; // Change label text to file name
  } else {
    ml_script_label.textContent = "Ml Script"; // Reset label if no file is selected
  }
});

train_data.addEventListener("change", function (event) {
  const file = event.target.files[0];
  if (file) {
    train_data_label.textContent = file.name; // Change label text to file name
  } else {
    train_data_label.textContent = "Train Data"; // Reset label if no file is selected
  }
});

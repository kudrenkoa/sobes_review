let getReviewButton = document.getElementById("get_reviews_btn");
let getReportsForm = document.getElementById("get_reports_form");
let uploadReviewButton = document.getElementById("post_review_btn");
let fileUpload = document.getElementById("upload");

let textInputs = {
  "group_by": "",
  "review_type": ""
};

function updateUploadButtonState() {
  uploadReviewButton.disabled = fileUpload.files.length == 0
}

function inputsAreInvalid() {
  return textInputs["group_by"] == "" || textInputs["review_type"] == "";
}

function updateGetReviewButtonDisabledState() {
  getReviewButton.disabled = inputsAreInvalid();
}

function updateGetReportsFormAction() {
  getReportsForm.action = `${window.location.href}reports/${textInputs["group_by"]}/${textInputs["review_type"]}`;
}

function updateGetForm(param, elementID) {
  textInputs[elementID] = param.options[param.selectedIndex].value;
  updateGetReviewButtonDisabledState();
  updateGetReportsFormAction();
}

updateGetReviewButtonDisabledState();
updateUploadButtonState();
updateGetReportsFormAction();

let getReviewButton = document.getElementById("get_reviews_btn");
let uploadReviewButton = document.getElementById("post_review_btn");
let fileUpload = document.getElementById("upload")
let textInputs = {
  "group_by": document.getElementById("group_by"),
  "review_type": document.getElementById("review_type")
};

function updateUploadButtonState() {
  uploadReviewButton.disabled = fileUpload.files.length == 0
}

function inputsAreInvalid() {
  return textInputs["group_by"].value == "" || textInputs["review_type"].value == "";
}

function updateGetReviewButtonDisabledState() {
  getReviewButton.disabled = inputsAreInvalid();
}

function updateGetForm(param, elementID) {
  textInputs[elementID].value = param.options[param.selectedIndex].value;
  updateGetReviewButtonDisabledState();
}

updateGetReviewButtonDisabledState();
updateUploadButtonState();
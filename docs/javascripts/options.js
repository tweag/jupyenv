function fetchOptions(path) {
  fetch(path)
    .then((response) => response.json())
    .then((json) => generateCommonMark(json))
    .then((json) => updateOptions(json))
}

function generateCommonMark(jsonObj) {
  let markdown = "";

  for (const [key, value] of Object.entries(jsonObj)) {
    markdown = markdown.concat("## ", key.replace('<', '&lt;').replace('>', '&gt;'), "\n");
    markdown = markdown.concat(value["description"], "\n\n");
    if ('type' in value) {
      markdown = markdown.concat("*_Type_*:", "\n");
      markdown = markdown.concat(value['type'], "\n\n");
    }
    if ('default' in value) {
      markdown = markdown.concat("*_Default_*:", "\n");
      markdown = markdown.concat("```", "\n");
      markdown = markdown.concat(JSON.stringify(value['default']), "\n\n");
      markdown = markdown.concat("```", "\n");
    }
    if ('example' in value) {
      markdown = markdown.concat("*_Example_*:", "\n");
      markdown = markdown.concat("```", "\n");
      markdown = markdown.concat(value['example'], "\n\n");
      markdown = markdown.concat("```", "\n");
    }
  }
  markdown = markdown.replace(/(?:\\[rn])+/g, "\n");

  return markdown;
}

function updateOptions(data) {
  let optionsInfo = document.getElementById("optionsInfo");
  var converter = new showdown.Converter();
  optionsInfo.innerHTML = converter.makeHtml(data);
}
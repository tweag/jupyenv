function fetchOptions(path) {
  fetch(path)
    .then((response) => response.json())
    .then((json) => nestJsonChildren(json))
    .then((json) => generateCommonMark(json))
    .then((json) => updateOptions(json))
    .then(() => nestOptionsInDOM())
}

function nestJsonChildren(jsonObj) {
  let prevKey = "random prev key";

  for (var key in jsonObj) {
    if (key.includes(prevKey)) {
      if (!jsonObj[prevKey].hasOwnProperty("children")) {
        jsonObj[prevKey].children = {};
      }
      jsonObj[prevKey].children[key] = jsonObj[key];
      delete jsonObj[key];
    } else {
      prevKey = key;
    }
  }

  return jsonObj;
}

function generateCommonMark(jsonObj, markdown = "", header = "## ") {
  for (const [key, value] of Object.entries(jsonObj)) {

    markdown = markdown.concat(header, key.replace('<', '&lt;').replace('>', '&gt;'), "\n");

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
    if ('children' in value) {
      markdown = generateCommonMark(value["children"], markdown, "#" + header)
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

function nestOptionsInDOM() {
  let possibleHeaders = ["H6", "H5", "H4", "H3", "H2"];
  let allOptions = document.getElementById("optionsInfo").children;

  possibleHeaders.forEach((headerElem, headerIdx, headerArray) => {
    let childList = [];

    for (var idx = allOptions.length - 1; idx >= 0; idx--) {
      let childElement = allOptions[idx];

      if (headerElem === childElement.nodeName) {
        let newDiv = document.createElement("div");
        childElement.parentNode.insertBefore(newDiv, childElement.nextElementSibling);
        childList.reverse().forEach((elem) => {
          newDiv.appendChild(elem);
        });
        childList = [];
      } else if (headerArray.slice(headerIdx).includes(childElement.nodeName)) {
        childList = [];
      } else {
        childList.push(childElement);
      }
    }
  })
}

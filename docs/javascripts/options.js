function fetchOptions(path) {
  fetch(path)
    .then((response) => response.json())
    .then((json) => nestJsonChildren(json))
    .then((json) => generateCommonMark(json))
    .then((json) => updateOptions(json))
    .then(() => nestOptionsInDOM())
    .then(() => makeOptionsCollapsible())
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
        newDiv.classList.add("collapsibleContentContainer");
        childElement.classList.add("collapsibleHeader");
        childElement.parentNode.insertBefore(newDiv, childElement.nextElementSibling);
        childList.reverse().forEach((elem) => {
          elem.classList.add("collapsibleContent");
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

function makeOptionsCollapsible() {
  var coll = document.getElementsByClassName("collapsibleHeader");

  for (var idx = 0; idx < coll.length; idx++) {
    coll[idx].addEventListener("click", function() {
      var content = this.nextElementSibling;
      if (content.style.maxHeight) {
        recursivelyCollapseOptions(this);
      } else {
        recursivelyExpandOptions(this, 0);
      }
    });
  }
}

function recursivelyCollapseOptions(element) {
  element.classList.remove("active");
  var content = element.nextElementSibling;
  content.style.maxHeight = null;
  for (let child of content.children) {
    if (child.classList.contains("collapsibleHeader")) {
      recursivelyCollapseOptions(child);
    }
  }
}

function recursivelyExpandOptions(element, childHeight = 0) {
  element.classList.add("active");
  var content = element.nextElementSibling;
  content.style.maxHeight = content.scrollHeight + childHeight + "px";

  possibleParentHeader = content.parentElement.previousElementSibling;
  if (possibleParentHeader.classList.contains("collapsibleHeader")) {
    recursivelyExpandOptions(possibleParentHeader, content.scrollHeight);
  }
}

function fetchOptions(path) {
  fetch(path)
    // TODO : eventually move to server side
    .then((response) => response.json())
    .then((json) => nestJsonChildren(json))
    .then((json) => generateCommonMark(json))
    .then((json) => updateOptions(json))
    // TODO : consider doing this in CSS
    .then(() => nestOptionsInDOM())
    .then(() => makeOptionsCollapsible())
    // this needs to stay in JS
    .then(() => addExpandAll())
    .then(() => addKernelIcons())
}

/**
 * Takes a flat JSON object and nests children based on key strings.
 *
 * The JSON object created from NixOS module options has all options listed at
 * the top level. The goal is to find options that are sub-options and append
 * them as children to their parent option.
 *
 * The function iterates forward through the object. If the current key starts
 * with the previous key, the current key is appended as a child of the
 * previous key. This carries on until there is no match and then the current
 * key becomes the new previous key.
 *
 * @param {Object} jsonObj The flat JSON object.
 *
 * @return {Object} The nested JSON object.
 */
function nestJsonChildren(jsonObj) {
  let keyList = [];
  // Key to store nested options.
  const nestingKey = "children";

  for (let currKey in jsonObj) {
    // The key list can change in the loop.
    let keyListLength = keyList.length;

    for (let unused = 0; unused < keyListLength; unused++) {
      // Grabs the most recent key added to the key list and checks if the
      // current key is a child.
      let prevKey = keyList.slice(-1)[0];
      if (currKey.startsWith(prevKey)) {
        // Insert the nesting key in between the key list elements and get the
        // object associated with the previous key to store the current key as
        // a child.
        let keyListWithChildren = keyList.flatMap((elem, idx) => idx ? [nestingKey, elem]: [elem])
        let prevObj = keyListWithChildren.reduce((obj, key) => obj[key], jsonObj);

        // First time adding a child.
        if (!prevObj.hasOwnProperty(nestingKey)) {
          prevObj.children = {};
        }

        // Add the child, delete it from the top level, and push its key to the
        // key list in case the next key is a child of the current.
        prevObj.children[currKey] = jsonObj[currKey];
        delete jsonObj[currKey];
        keyList.push(currKey);
        break;
      } else {
        // If the current key is not a child, pop the last element from the key
        // list and check the next level up.
        keyList.pop();
      }
    }

    // Used in the first iteration and whenever the current key has no parent.
    if (keyList.length === 0) {
      keyList.push(currKey);
    }
  }

  return jsonObj;
}

/**
 * Creates a CommonMark compliant markdown from JSON similar to how optionsCommonMark and generateDoc.py do in nixpkgs.
 * https://github.com/NixOS/nixpkgs/blob/42ad7722055405860eadccee37327de3a3fe9f00/nixos/lib/make-options-doc/default.nix#L103
 * https://github.com/NixOS/nixpkgs/blob/42ad7722055405860eadccee37327de3a3fe9f00/nixos/lib/make-options-doc/generateDoc.py#L37
 *
 * Unlike the aforementioned functions, this function is recursive. The reason
 * is so that children are converted to a header level one lower than their
 * parent. Also the examples are not stringify'd as testing showed it renders
 * better without.
 *
 * @param {Object} jsonObj      A nested JSON object.
 * @param {String} markdown=""  Where the output markdown is stored.
 * @param {String} header="## " The header level of the current keys being converted.
 *
 * @return {String} The resulting markdown.
 *
 */

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
      // Examples look better when they are not stringify'd.
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

        let headerDiv = document.createElement("div");
        headerDiv.classList.add("collapsibleHeaderContainer");
        childElement.parentNode.insertBefore(headerDiv, childElement);
        headerDiv.appendChild(childElement);
      } else if (headerArray.slice(headerIdx).includes(childElement.nodeName)) {
        childList = [];
      } else {
        childList.push(childElement);
      }
    }
  })
}

function makeOptionsCollapsible() {
  var coll = document.getElementsByClassName("collapsibleHeaderContainer");

  for (var idx = 0; idx < coll.length; idx++) {
    coll[idx].addEventListener("click", function() {
      var content = this.nextElementSibling;
      if (content.style.maxHeight) {
        collapseOptions(this);
      } else {
        expandOptions(this);
      }
    });
  }
}

function collapseOptions(element) {
  recursivelyCollapseOptions(element);
  setButtonToExpand(element);
  setTimeout(updateParentDuringChildToggle, 250, element);
}

function recursivelyCollapseOptions(element) {
  element.classList.remove("active");
  var content = element.nextElementSibling;
  content.style.maxHeight = null;
  for (let child of content.children) {
    if (child.classList.contains("collapsibleHeaderContainer")) {
      recursivelyCollapseOptions(child);
    }
  }
}

function setButtonToExpand(element) {
  var content = element.nextElementSibling;
  content
    .querySelectorAll('.expandAllButton')
    .forEach(function (currentValue, currentIndex, listObj) {
      currentValue.style.display = "inline-block";
    });
  content
    .querySelectorAll('.collapseAllButton')
    .forEach(function (currentValue, currentIndex, listObj) {
      currentValue.style.display = "none";
    });
}

function updateParentDuringChildToggle(element) {
  var possibleParentContent = element.parentElement;
  if (possibleParentContent.classList.contains("collapsibleContentContainer")) {
    possibleParentContent.style.maxHeight = possibleParentContent.scrollHeight + "px";
  }
}

function expandOptions(element) {
  recursivelyExpandOptions(element, 0);
  setTimeout(updateParentDuringChildToggle, 250, element);
}

function recursivelyExpandOptions(element, childHeight = 0) {
  element.classList.add("active");
  var content = element.nextElementSibling;
  content.style.maxHeight = content.scrollHeight + childHeight + "px";

  possibleParentHeader = content.parentElement.previousElementSibling;
  if (possibleParentHeader.classList.contains("collapsibleHeaderContainer")) {
    recursivelyExpandOptions(possibleParentHeader, content.scrollHeight);
  }
}

function addExpandAll() {
  var contentContainers = [].slice.call(document.getElementsByClassName("collapsibleContentContainer"));

  contentContainers.forEach((element) => {
    var contentChildren = [].slice.call(element.children);
    if (contentChildren.some((child) => child.classList.contains("collapsibleHeaderContainer"))) {

      var expandAllButton = document.createElement("button");
      expandAllButton.type = "button";
      expandAllButton.innerText = "expand all";
      expandAllButton.classList.add("expandAllButton", "toggleAllButton");
      expandAllButton.classList.add("md-button");


      var collapseAllButton = document.createElement("button");
      collapseAllButton.type = "button";
      collapseAllButton.innerText = "collapse all";
      collapseAllButton.classList.add("collapseAllButton", "toggleAllButton");
      collapseAllButton.classList.add("md-button");
      collapseAllButton.style.display = "none";

      expandAllButton.addEventListener("click", function() {
        var headerChildren = [].slice.call(this.parentElement.children)
          .filter(element => element.classList.contains("collapsibleHeaderContainer"));
        headerChildren.forEach(elem => expandOptions(elem));
        this.style.display = "none";
        collapseAllButton.style = "inline-block";
      });

      collapseAllButton.addEventListener("click", function() {
        var headerChildren = [].slice.call(this.parentElement.children)
          .filter(element => element.classList.contains("collapsibleHeaderContainer"));
        headerChildren.forEach(elem => collapseOptions(elem));
        this.style.display = "none";
        expandAllButton.style = "inline-block";
      });

      element.prepend(expandAllButton);
      element.prepend(collapseAllButton);
    }
  });
}

function addKernelIcons() {
  var allHeaders = [].slice.call(document.getElementsByClassName("collapsibleHeaderContainer"));
  var regexKernels = RegExp("kernel\.([a-z]*)$");
  var onlyKernelHeaders = allHeaders.filter((element) => {
    return regexKernels.test(element.innerText);
  });

  var imgSizeOffsetPercent = 0.8;

  onlyKernelHeaders.forEach((element) => {
    var kernelName = element.innerText.match(regexKernels)[1];
    var img = document.createElement("img");
    img.src = "../assets/logos/kernels/" + kernelName + "-logo64.png";
    img.style.position = "absolute";

    var imgHeight = Math.floor(imgSizeOffsetPercent * element.offsetHeight);
    var imgHeightOffset = element.offsetHeight - imgHeight;
    img.style.height = imgHeight + "px";
    img.style.transform = "translate(-150%, " + Math.floor(imgHeightOffset / 2) + "px)";

    element.insertBefore(img, element.children[0]);
  });
}

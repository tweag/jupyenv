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
    .then(() => addExpandCollapseAllButtons())
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
 * parent. This makes it easier to nest options in the DOM. Also the examples
 * are not stringify'd as testing showed it renders better without.
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

/**
 * Updates the DOM with the options Markdown.
 *
 * @param {String} data The options markdown.
 */
function updateOptions(data) {
  let optionsContent = document.getElementById("optionsContent");
  var converter = new showdown.Converter();
  optionsContent.innerHTML = converter.makeHtml(data);
}

/**
 * Nests options with lower heading levels under those with higher.
 *
 * The function loops over all possible headings from lowest to highest level,
 * and then through the elements where the markdown is stored in reverse order.
 * If the current element is not a header, it is appended to a child list. If a
 * heading is encountered that is higher than the current heading level being
 * searched, the child list is reset. Finally, if a heading level of the
 * current iteration is encountered, the children are moved to a content
 * element and the heading is moved to a heading element. This is useful so
 * icons and buttons can be added later without worring about the order of the
 * DOM changing.
 */
function nestOptionsInDOM() {
  ["H6", "H5", "H4", "H3", "H2"].forEach((headerElem, headerIdx, headerArray) => {
    let childList = [];

    // Go through the options elements in the DOM in reverse order. This was
    // the easiest way as you can collect elements in a list and relocate them
    // as appropriate or reset the list. Going forward through the elements is
    // much more complicated.
    Array.from(document.getElementById("optionsContent").children)
      .reverse()
      .forEach((childElement) => {
        if (headerElem === childElement.nodeName) {
          // Current element is a heading of the current iteration.

          // Create a new DIV for the content under the heading and add the
          // content. Empty the child list for the next iteration. Headings
          // lower than H2 can be children of higher headings.
          let contentDiv = document.createElement("div");
          childElement.insertAdjacentElement('afterend', contentDiv);
          contentDiv.classList.add("collapsibleContentContainer");
          childList.reverse().forEach((child) => {
            child.classList.add("collapsibleContent");
            contentDiv.append(child);
          });
          childList = [];

          // Create a new DIV for the heading and add the heading. This needs
          // to happen last as the heading is moved in the DOM at this point.
          let headerDiv = document.createElement("div");
          childElement.insertAdjacentElement('beforebegin', headerDiv);
          headerDiv.classList.add("collapsibleHeaderContainer");
          childElement.classList.add("collapsibleHeader");
          headerDiv.append(childElement);
        } else if (headerArray.slice(headerIdx + 1).includes(childElement.nodeName)) {
          // Current element is a heading higher than the current iteration.
          childList = [];
        } else {
          // Current element is a heading lower than the current iteration or
          // anything else.
          childList.push(childElement);
        }
    });
  });
}

/**
 * Loops through all the collapsible heading containers and adds the click to
 * collapse/expand functionality.
 */
function makeOptionsCollapsible() {
  Array.from(document.getElementsByClassName("collapsibleHeaderContainer"))
    .forEach((element) => {
      element.addEventListener("click", function() {
        var content = this.nextElementSibling;
        if (content.style.maxHeight) {
          collapseOptions(this);
        } else {
          expandOptions(this);
        }
      });
    });
}

/**
 * Things to do when collapsing a heading's content.
 */
function collapseOptions(element) {
  recursivelyCollapseOptions(element);
  setButtonToExpand(element);
  // The content needs to finish collapsing before the parents can be updated.
  setTimeout(updateParentDuringChildToggle, 250, element);
}

/**
 * Recursively collapses a heading. Resets the content maxHeight so it
 * collapses, removes the active class so the heading is not highlighted, and
 * checks the children to see if there is a heading container to recurse into.
 */
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

/**
 * When a heading is collapsed, reset the expand/collapse all buttons.
 */
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

/**
 * When a heading container's content is collapsed, the parent container's
 * style needs to be updated if one exists.
 */
function updateParentDuringChildToggle(element) {
  var possibleParentContent = element.parentElement;
  if (possibleParentContent.classList.contains("collapsibleContentContainer")) {
    possibleParentContent.style.maxHeight = possibleParentContent.scrollHeight + "px";
  }
}

/**
 * Things to do when expanding a heading's content.
 */
function expandOptions(element) {
  recursivelyExpandOptions(element, 0);
  // The content needs to finish expanding before the parents can be updated.
  setTimeout(updateParentDuringChildToggle, 250, element);
}

/**
 * Expands a heading container's content.
 *
 * This is done by updating the contents maxHeight style.
 * Recursively checks parents element's previous sibling if they are a heading
 * container and updates the content maxHeight style if so.
 */
function recursivelyExpandOptions(element, childHeight = 0) {
  element.classList.add("active");
  var content = element.nextElementSibling;
  content.style.maxHeight = content.scrollHeight + childHeight + "px";

  let possibleParentHeader = content.parentElement.previousElementSibling;
  if (possibleParentHeader.classList.contains("collapsibleHeaderContainer")) {
    recursivelyExpandOptions(possibleParentHeader, content.scrollHeight);
  }
}

/**
 * Create expand/collapse all buttons in content containers that have content
 * container children.
 */
function addExpandCollapseAllButtons() {
  Array.from(document.getElementsByClassName("collapsibleContentContainer"))
    .forEach((container) => {
      var contentChildren = Array.from(container.children);
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
          Array.from(this.parentElement.children)
            .filter(container => container.classList.contains("collapsibleHeaderContainer"))
            .forEach(elem => expandOptions(elem));
          this.style.display = "none";
          collapseAllButton.style = "inline-block";
        });

        collapseAllButton.addEventListener("click", function() {
          Array.from(this.parentElement.children)
            .filter(container => container.classList.contains("collapsibleHeaderContainer"))
            .forEach(elem => collapseOptions(elem));
          this.style.display = "none";
          expandAllButton.style = "inline-block";
        });

        container.prepend(expandAllButton);
        container.prepend(collapseAllButton);
      }
    });
}

/**
 * Adds kernel icons next to the associated option heading.
 */
function addKernelIcons() {
  // Only look for things that start with "kernel." and ends with some kernel
  // name (e.g. kernel.bash or kernel.python but not kernel.python.science).
  var regexKernels = RegExp("kernel\.([a-z]*)$");

  // Make icons slightly shorter than the heading they are next to.
  var imgSizeOffsetPercent = 0.8;

  // Get only heading containers that match the regex and put the icon next to it.
  Array.from(document.getElementsByClassName("collapsibleHeaderContainer"))
    .filter(element => regexKernels.test(element.innerText))
    .forEach((element) => {
      var kernelName = element.innerText.match(regexKernels)[1];
      var img = document.createElement("img");
      img.src = "../assets/logos/kernels/" + kernelName + "-logo64.png";
      img.style.position = "absolute";

      var imgHeight = Math.floor(imgSizeOffsetPercent * element.offsetHeight);
      var imgHeightOffset = element.offsetHeight - imgHeight;
      img.style.height = imgHeight + "px";
      img.style.transform = "translate(-150%, " + Math.floor(imgHeightOffset / 2) + "px)";

      element.prepend(img);
    });
}

export {
  fetchOptions,
  nestJsonChildren,
  generateCommonMark,
  updateOptions,
  nestOptionsInDOM,
  makeOptionsCollapsible,
  addExpandCollapseAllButtons,
  addKernelIcons
};

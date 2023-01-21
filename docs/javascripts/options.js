/**
 * Loop through all the option buttons and add click to collapse/expand.
 */
function makeOptionsCollapsible() {
  document.querySelectorAll('.option-button').forEach((button) => {
    button.addEventListener('click', () => {
      const isOpened = button.getAttribute('aria-expanded') === "true";
      if (isOpened ? closeOption(button) : openOption(button));
    });
  });

  document.querySelectorAll('button.toggle-children').forEach((button) => {
    button.addEventListener('click', () => {
      const isOpened = button.getAttribute('aria-expanded') === "true";
      button.parentElement.querySelectorAll('li>div>button.option-button').forEach((childButton) => {
        if (isOpened ? closeOption(childButton) : openOption(childButton));
      });
      button.setAttribute('aria-expanded', !isOpened);
    });
  });
}

/**
 * Open an option.
 */
function openOption(button) {
  button.setAttribute('aria-expanded', "true");
  var content = getNextSibling(button, '.collapsible-content');
  $(content).slideDown();
}

/**
 * Close an option and all children, and reset the expand all button.
 */
function closeOption(button) {
  button.setAttribute('aria-expanded', "false");
  var content = getNextSibling(button, '.collapsible-content');
  $(content).slideUp();

  /* reset toggle children button */
  var toggleChildrenButton = content.querySelector('button.toggle-children');
  if (toggleChildrenButton) {
    toggleChildrenButton.setAttribute('aria-expanded', 'false');
  }

  /* close children too */
  content.querySelectorAll('.option-button').forEach((childButton) => {
    if (childButton.getAttribute('aria-expanded') === "true") {
      closeOption(childButton);
    }
  });
}

/**
 * Get next sibling of a given selector.
 * credit: https://gomakethings.com/finding-the-next-and-previous-sibling-elements-that-match-a-selector-with-vanilla-js/
 */
function getNextSibling(elem, selector) {
  // Get the next sibling element
  var sibling = elem.nextElementSibling;

  // If there's no selector, return the first sibling
  if (!selector) return sibling;

  // If the sibling matches our selector, use it
  // If not, jump to the next sibling and continue the loop
  while (sibling) {
    if (sibling.matches(selector)) return sibling;
    sibling = sibling.nextElementSibling
  }
};

/**
 * Get previous sibling of a given selector.
 * credit: https://gomakethings.com/finding-the-next-and-previous-sibling-elements-that-match-a-selector-with-vanilla-js/
 */
function getPrevSibling(elem, selector) {
  // Get the next sibling element
  var sibling = elem.previousElementSibling;

  // If there's no selector, return the first sibling
  if (!selector) return sibling;

  // If the sibling matches our selector, use it
  // If not, jump to the next sibling and continue the loop
  while (sibling) {
          if (sibling.matches(selector)) return sibling;
          sibling = sibling.previousElementSibling;
  }
};

/**
 * If an anchor is in the URL, open the options ancestry and scroll to it.
 */
function goToAnchor() {
  var pathOnly = window.location.origin + window.location.pathname;
  var pathWithAnchor = window.location.href;
  var anchor = pathWithAnchor.slice(pathWithAnchor.indexOf(pathOnly) + pathOnly.length);

  if (anchor !== "") {
    var content = document.querySelector(anchor);
    openOptionRecursively(content);
    setTimeout(
      () => {
        content.scrollIntoView({behavior: "smooth", block: "center"});
      },
      500
    );
  }

}

/**
 * Recursively open options start with the furthest ancestor.
 */
function openOptionRecursively(content) {
  var button = getPrevSibling(content, '.option-button');
  var parentContent = button.closest('.collapsible-content');
  if (parentContent !== null) {
    openOptionRecursively(parentContent);
  }
  button.click();
}

function initializePage() {
  document
    .querySelectorAll('[aria-expanded="true"].option-button')
    .forEach((elem) => {
      elem.setAttribute('aria-expanded', 'false');
      getNextSibling(elem, '.collapsible-content').style.display = "none";
    });

  document
    .querySelectorAll('.option-button')
    .forEach(elem => elem.style.setProperty('--icon-visibility', 'visible'));

  document
    .querySelectorAll('.toggle-children')
    .forEach(elem => elem.style.display = "block");

  goToAnchor();
}

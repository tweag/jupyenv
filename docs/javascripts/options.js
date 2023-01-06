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

function initializePage() {
  document
    .querySelectorAll('[aria-expanded="true"]')
    .forEach((elem) => {
      elem.setAttribute('aria-expanded', 'false');
      elem.nextElementSibling.style.display = "none";
    });

  document
    .querySelectorAll('.option-button')
    .forEach(elem => elem.style.setProperty('--icon-visibility', 'visible'));

  document
    .querySelectorAll('.toggle-children')
    .forEach(elem => elem.style.display = "block");
}

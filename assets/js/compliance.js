document.querySelectorAll('[data-compliance-device]').forEach(function(device) {
  var sections = Array.from(device.querySelectorAll('.compliance-detail'));
  var links = Array.from(device.querySelectorAll('[data-compliance-select]'));
  var prompt = device.querySelector('[data-compliance-prompt]');
  var close = device.querySelector('[data-compliance-close]');
  var selectedLink = null;

  function reset() {
    sections.forEach(function(section) { section.hidden = true; });
    links.forEach(function(link) {
      link.setAttribute('aria-expanded', 'false');
      link.classList.remove('is-selected');
    });
    prompt.hidden = false;
    close.hidden = true;
  }

  function select(link, focus) {
    var id = link.getAttribute('data-compliance-select');
    var section = sections.find(function(item) { return item.id === id; });
    if (!section) return;
    reset();
    selectedLink = device.querySelector('.compliance-cell[data-compliance-select="' + id + '"]') || link;
    section.hidden = false;
    prompt.hidden = true;
    close.hidden = false;
    links.filter(function(item) { return item.getAttribute('data-compliance-select') === id; }).forEach(function(item) {
      item.setAttribute('aria-expanded', 'true');
      item.classList.add('is-selected');
    });
    if (focus) {
      section.focus({preventScroll: true});
      section.scrollIntoView({block: 'nearest'});
    }
  }

  reset();
  links.forEach(function(link) {
    link.addEventListener('click', function(event) {
      if (event.ctrlKey || event.metaKey || event.shiftKey || event.altKey) return;
      event.preventDefault();
      select(link, true);
    });
  });
  close.addEventListener('click', function() {
    reset();
    if (selectedLink) selectedLink.focus();
  });
  device.addEventListener('keydown', function(event) {
    if (event.key === 'Escape' && !close.hidden) {
      event.preventDefault();
      close.click();
    }
  });
  function selectHash() {
    var link = links.find(function(item) { return item.hash === window.location.hash; });
    if (link) select(link, false);
  }
  selectHash();
  window.addEventListener('hashchange', selectHash);
});

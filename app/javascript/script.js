// Modal Window

function fadeIn(node, duration) {
  if (getComputedStyle(node).display !== 'none') return;

  if (node.style.display === 'none') {
    node.style.display = '';
  } else {
    node.style.display = 'block';
  }
  node.style.opacity = 0;

  var start = performance.now();

  requestAnimationFrame(function tick(timestamp) {
    var easing = (timestamp - start) / duration;

    node.style.opacity = Math.min(easing, 1);

    if (easing < 1) {
      requestAnimationFrame(tick);
    } else {
      node.style.opacity = '';
    }
  });
}

function fadeOut(node, duration) {
  node.style.opacity = 1;

  var start = performance.now();

  requestAnimationFrame(function tick(timestamp) {
    var easing = (timestamp - start) / duration;

    node.style.opacity = Math.max(1 - easing, 0);

    if (easing < 1) {
      requestAnimationFrame(tick);
    } else {
      node.style.opacity = '';
      node.style.display = 'none';
    }
  });
}

window.addEventListener("load",function(){
  var fadeInBtnElmt  = document.getElementById('openModal');
  if (!fadeInBtnElmt){ return false;}

  var fadeOutBtnElmt = document.getElementById("modalBg");
  if (!fadeOutBtnElmt){ return false;}

fadeInBtnElmt.addEventListener("click", () => {
  fadeIn(document.getElementById('modalArea'), 300);
});

fadeOutBtnElmt.addEventListener("click", () => {
  fadeOut(document.getElementById('modalArea'), 300);
});
});

// slideToggle

const slideUp = (el, duration = 300) => {
  el.style.height = el.offsetHeight + "px";
  el.offsetHeight;
  el.style.transitionProperty = "height, margin, padding";
  el.style.transitionDuration = duration + "ms";
  el.style.transitionTimingFunction = "ease";
  el.style.overflow = "hidden";
  el.style.height = 0;
  el.style.paddingTop = 0;
  el.style.paddingBottom = 0;
  el.style.marginTop = 0;
  el.style.marginBottom = 0;
  setTimeout(() => {
    el.style.display = "none";
    el.style.removeProperty("height");
    el.style.removeProperty("padding-top");
    el.style.removeProperty("padding-bottom");
    el.style.removeProperty("margin-top");
    el.style.removeProperty("margin-bottom");
    el.style.removeProperty("overflow");
    el.style.removeProperty("transition-duration");
    el.style.removeProperty("transition-property");
    el.style.removeProperty("transition-timing-function");
  }, duration);
};

const slideDown = (el, duration = 300) => {
  el.style.removeProperty("display");
  let display = window.getComputedStyle(el).display;
  if (display === "none") {
    display = "block";
  }
  el.style.display = display;
  let height = el.offsetHeight;
  el.style.overflow = "hidden";
  el.style.height = 0;
  el.style.paddingTop = 0;
  el.style.paddingBottom = 0;
  el.style.marginTop = 0;
  el.style.marginBottom = 0;
  el.offsetHeight;
  el.style.transitionProperty = "height, margin, padding";
  el.style.transitionDuration = duration + "ms";
  el.style.transitionTimingFunction = "ease";
  el.style.height = height + "px";
  el.style.removeProperty("padding-top");
  el.style.removeProperty("padding-bottom");
  el.style.removeProperty("margin-top");
  el.style.removeProperty("margin-bottom");
  setTimeout(() => {
    el.style.removeProperty("height");
    el.style.removeProperty("overflow");
    el.style.removeProperty("transition-duration");
    el.style.removeProperty("transition-property");
    el.style.removeProperty("transition-timing-function");
  }, duration);
};

const slideToggle = (el, duration = 300) => {
  if (window.getComputedStyle(el).display === "none") {
    return slideDown(el, duration);
  } else {
    return slideUp(el, duration);
  }
};

const el = document.querySelector('.dropdown__lists');
const slideToggleBtn = document.querySelector(".dropdown__menu");

slideToggleBtn.addEventListener("click", () => {
  slideToggle(el, 300);
  return false;
});
import Typed from 'typed.js';

const loadPageHeader = () => {
  new Typed('#typing-animation', {
    strings: ["Picking a restaurant for you...", "It'll be awesome!"],
    typeSpeed: 50,
    loop: true
  });
}

export { loadPageHeader };

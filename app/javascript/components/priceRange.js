const selectPrice = () => {
  const priceId = `price${event.currentTarget.innerHTML.length}`;
  document.getElementById(priceId).classList.toggle("selected");
};

[price1, price2, price3, price4, price5].forEach((element) => {
  element.addEventListener("click", selectPrice);
});

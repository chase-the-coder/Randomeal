const selectPrice = () => {
  event.currentTarget.classList.toggle("selected");

  const priceRanges = [];
  const priceInput = document.getElementById("price-hidden");

  document.querySelectorAll(".selected").forEach((element) => {
    priceRanges.push(element.innerHTML.length);
  });

  if (priceRanges.length == 0) {
    priceInput.value = "";
  } else {
    priceInput.value = priceRanges.join(",");
  }
};

document.querySelectorAll(".price-range").forEach((element) => {
  element.addEventListener("click", selectPrice);
});

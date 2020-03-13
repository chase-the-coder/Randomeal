if (document.getElementById("myRange")) {
  document.getElementById("myRange").addEventListener('change', (event) => {
    document.getElementById("distance").value = document.getElementById("demo").innerText
  });
}

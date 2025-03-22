const maxVisibleButtons = 6;
let startPage = 1; // Keeps track of the first visible button

function createPagination(location) {
    paginationContainer.innerHTML = '';
    const properties = locations[location];
    if (!properties) {return}
    const totalPages = Math.ceil(properties.length / cardsPerPage);

    if (!totalPages || totalPages === 1) return;

    function renderButtons() {
        paginationContainer.innerHTML = '';

        // "Previous" button
        const prevBtn = document.createElement("button");
        prevBtn.textContent = "«";
        prevBtn.classList.add("pagination-btn");
        prevBtn.disabled = startPage === 1; // Disable if at the start
        prevBtn.onclick = () => {
            if (startPage > 1) {
                startPage = Math.max(1, startPage - maxVisibleButtons);
                renderButtons();
            }
        };
        paginationContainer.appendChild(prevBtn);

        // Create page buttons
        for (let i = startPage; i < startPage + maxVisibleButtons && i <= totalPages; i++) {
            const btn = document.createElement("button");
            btn.textContent = i;
            btn.classList.add("pagination-btn");
            btn.onclick = () => {
                currentPage = i;
                createCards(location, currentPage);
            };
            paginationContainer.appendChild(btn);
        }

        // "Next" button
        const nextBtn = document.createElement("button");
        nextBtn.textContent = "»";
        nextBtn.classList.add("pagination-btn");
        nextBtn.disabled = startPage + maxVisibleButtons > totalPages; // Disable if at the end
        nextBtn.onclick = () => {
            if (startPage + maxVisibleButtons <= totalPages) {
                startPage = Math.min(totalPages - maxVisibleButtons + 1, startPage + maxVisibleButtons);
                renderButtons();
            }
        };
        paginationContainer.appendChild(nextBtn);
    }

    renderButtons();
}

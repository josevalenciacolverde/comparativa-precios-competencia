<!DOCTYPE html>
<html lang="es">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Comparativa Interactiva de Precios por Categoría</title>
    <script src="https://cdn.tailwindcss.com"></script>
    <link rel="preconnect" href="https://fonts.googleapis.com">
    <link rel="preconnect" href="https://fonts.gstatic.com" crossorigin>
    <link href="https://fonts.googleapis.com/css2?family=Inter:wght@400;500;600;700&display=swap" rel="stylesheet">
    <style>
        body {
            font-family: 'Inter', sans-serif;
            background-color: #f3f4f6;
        }
        .table-container::-webkit-scrollbar {
            height: 8px;
        }
        .table-container::-webkit-scrollbar-track {
            background: #f1f1f1;
            border-radius: 10px;
        }
        .table-container::-webkit-scrollbar-thumb {
            background: #888;
            border-radius: 10px;
        }
        .table-container::-webkit-scrollbar-thumb:hover {
            background: #555;
        }
        .base-price {
            background-color: #fef08a !important; /* amarillo claro */
            border: 2px solid #facc15; /* amarillo más oscuro */
        }
        .price-cell {
            position: relative;
            padding-top: 1.5rem !important;
            text-align: center;
        }
        .percentage-diff {
            position: absolute;
            top: 2px;
            left: 50%;
            transform: translateX(-50%);
            font-size: 0.75rem;
            font-weight: 600;
            padding: 2px 4px;
            border-radius: 4px;
            white-space: nowrap;
        }
    </style>
</head>
<body class="antialiased text-slate-800">

    <div class="container mx-auto p-4 sm:p-6 lg:p-8">
        
        <!-- Encabezado -->
        <div class="mb-6">
            <h1 class="text-3xl font-bold text-slate-900">Comparativa Interactiva de Precios</h1>
            <p class="text-lg text-slate-600">Análisis de tarifas de alquiler de vehículos - <span class="font-semibold">martes 12/08/2025</span></p>
        </div>

        <!-- Panel de Control -->
        <div class="bg-white p-4 rounded-xl shadow-md mb-6 flex flex-wrap items-center gap-4">
            <div class="flex-grow">
                <label for="baseAgency" class="block text-sm font-medium text-gray-700 mb-1">Comparar desde Agencia:</label>
                <select id="baseAgency" class="w-full p-2 border border-gray-300 rounded-md shadow-sm focus:ring-green-500 focus:border-green-500">
                    <option value="">Seleccionar Agencia</option>
                </select>
            </div>
            <div class="flex-grow">
                <label for="baseCategory" class="block text-sm font-medium text-gray-700 mb-1">Categoría de Referencia:</label>
                <select id="baseCategory" class="w-full p-2 border border-gray-300 rounded-md shadow-sm focus:ring-green-500 focus:border-green-500" disabled>
                     <option value="">Seleccionar Categoría</option>
                </select>
            </div>
            <div class="flex-shrink-0 pt-6">
                 <button id="resetButton" class="bg-red-600 text-white px-4 py-2 rounded-md hover:bg-red-700 transition-colors">Resetear</button>
            </div>
        </div>

        <!-- Contenedor de la tabla -->
        <div class="bg-white rounded-xl shadow-lg overflow-hidden">
            <div class="table-container overflow-x-auto">
                <table id="pricesTable" class="w-full text-sm text-left text-gray-500">
                    <thead class="text-xs text-white uppercase" style="background-color: #05662B;">
                        <tr>
                            <th scope="col" class="px-4 py-3 rounded-tl-xl min-w-[120px]">Agencia</th>
                            <th scope="col" class="px-4 py-3 min-w-[120px]">Categoría</th>
                            <th scope="col" class="px-4 py-3 min-w-[120px]">Booking Group</th>
                            <th scope="col" class="px-4 py-3 min-w-[120px]">Carnect</th>
                            <th scope="col" class="px-4 py-3 min-w-[120px]">Rentcars</th>
                            <th scope="col" class="px-4 py-3 min-w-[130px]">Booking Rental Cars</th>
                            <th scope="col" class="px-4 py-3 min-w-[120px]">Despegar</th>
                            <th scope="col" class="px-4 py-3 min-w-[120px]">Auto Europe</th>
                            <th scope="col" class="px-4 py-3 rounded-tr-xl min-w-[120px]">Web</th>
                        </tr>
                    </thead>
                    <tbody>
                        <!-- Filas de datos generadas por JS -->
                    </tbody>
                </table>
            </div>
        </div>
    </div>

<script>
document.addEventListener('DOMContentLoaded', function () {
    // --- DATOS Y CONFIGURACIÓN ---
    const tableData = [
        { agency: 'LOCALIZA', category: 'CE', prices: { 'Booking Group': '$57.894', Carnect: '$64.627', Rentcars: '$56.613', 'Booking Rental Cars': 'US$43', Despegar: '$61.130', 'Auto Europe': '-', Web: '$54.930' } },
        { agency: 'LOCALIZA', category: 'FH', prices: { 'Booking Group': '$75.214', Carnect: '$72.500', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '$78.191', 'Auto Europe': '-', Web: '$109.960' } },
        { agency: 'LOCALIZA', category: 'FX', prices: { 'Booking Group': '$84.563', Carnect: '$91.766', Rentcars: '$82.718', 'Booking Rental Cars': '-', Despegar: '$89.240', 'Auto Europe': '-', Web: '$80.320' } },
        { agency: 'LOCALIZA', category: 'GX', prices: { 'Booking Group': '$104.462', Carnect: '$155.031', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '-', 'Auto Europe': '-', Web: '$148.680' } },
        { agency: 'HERTZ', category: 'CE', prices: { 'Booking Group': '$65.546', Carnect: '$64.232', Rentcars: '$63.390', 'Booking Rental Cars': 'US$49', Despegar: '$68.986', 'Auto Europe': '-', Web: '$74.113' } },
        { agency: 'HERTZ', category: 'FS', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '-', 'Auto Europe': '-', Web: '$75.610' } },
        { agency: 'HERTZ', category: 'FX', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '$70.609', 'Auto Europe': '-', Web: '$93.981' } },
        { agency: 'HERTZ', category: 'GH', prices: { 'Booking Group': '$110.218', Carnect: '$104.951', Rentcars: '$112.897', 'Booking Rental Cars': 'US$83', Despegar: '$122.858', 'Auto Europe': '-', Web: '$122.235' } },
        { agency: 'HERTZ', category: 'P', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': 'US$123', Despegar: '$159.715', 'Auto Europe': '-', Web: '$181.933' } },
        { agency: 'ALWAYS', category: 'CE', prices: { 'Booking Group': '-', Carnect: '$63.495', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '-', 'Auto Europe': '-', Web: '$51.839' } },
        { agency: 'ALWAYS', category: 'FS', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '-', 'Auto Europe': '-', Web: '$60.682' } },
        { agency: 'ALWAYS', category: 'FH', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '$72.751', 'Booking Rental Cars': '-', Despegar: '$60.000', 'Auto Europe': '-', Web: '$63.661' } },
        { agency: 'ALWAYS', category: 'FX', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '$65.000', 'Auto Europe': '-', Web: '-' } },
        { agency: 'ALWAYS', category: 'P', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '$150.000', 'Auto Europe': '-', Web: '$102.522' } },
        { agency: 'AVIS', category: 'CE', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '-', 'Auto Europe': '-', Web: '$70.881' } },
        { agency: 'AVIS', category: 'FX', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '-', 'Auto Europe': '-', Web: '$76.066' } },
        { agency: 'AVIS', category: 'F', prices: { 'Booking Group': '-', Carnect: '$153.198', Rentcars: '$182.220', 'Booking Rental Cars': '-', Despegar: '$182.724', 'Auto Europe': '-', Web: '$218.454' } },
        { agency: 'AVIS', category: 'GY', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '-', 'Auto Europe': '-', Web: '$213.018' } },
        { agency: 'AVIS', category: 'PX', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '-', 'Auto Europe': '-', Web: '$241.406' } },
        { agency: 'DUVROKNI', category: 'FS', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '-', 'Auto Europe': '-', Web: '$57.500' } },
        { agency: 'DUVROKNI', category: 'LE', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '-', 'Auto Europe': '-', Web: '$155.250' } },
        { agency: 'DUVROKNI', category: 'P', prices: { 'Booking Group': '-', Carnect: '-', Rentcars: '-', 'Booking Rental Cars': '-', Despegar: '-', 'Auto Europe': '-', Web: '$155.250' } },
    ];

    const agencies = [...new Set(tableData.map(item => item.agency))];
    const providers = ['Booking Group', 'Carnect', 'Rentcars', 'Booking Rental Cars', 'Despegar', 'Auto Europe', 'Web'];
    const exchangeRate = 1250; 

    const agencyColors = {
        'LOCALIZA': { text: '#05662B', bg: '#f0fdf4', border: '#a7f3d0' },
        'HERTZ':    { text: '#ca8a04', bg: '#fefce8', border: '#fde047' },
        'AVIS':     { text: '#b91c1c', bg: '#fee2e2', border: '#fca5a5' },
        'DUVROKNI': { text: '#c2410c', bg: '#fff7ed', border: '#fdba74' },
        'ALWAYS':   { text: '#1d4ed8', bg: '#eff6ff', border: '#bfdbfe' }
    };

    const agencySelect = document.getElementById('baseAgency');
    const categorySelect = document.getElementById('baseCategory');
    const tableBody = document.querySelector('#pricesTable tbody');
    const resetButton = document.getElementById('resetButton');

    // --- FUNCIONES AUXILIARES ---
    function parsePrice(priceString) {
        if (typeof priceString !== 'string' || priceString.trim() === '-') return null;
        const firstPrice = priceString.split('/')[0].trim();
        const isUSD = firstPrice.startsWith('US$');
        const number = parseFloat(firstPrice.replace(/[^0-9.,]+/g, '').replace('.', '').replace(',', '.'));
        if (isNaN(number)) return null;
        return isUSD ? number * exchangeRate : number;
    }

    function populateAgencyDropdown() {
        agencies.forEach(agency => {
            const option = document.createElement('option');
            option.value = agency;
            option.textContent = agency;
            agencySelect.appendChild(option);
        });
    }

    function populateCategoryDropdown(selectedAgency = null) {
        const currentCategory = categorySelect.value;
        categorySelect.innerHTML = '<option value="">Seleccionar Categoría</option>';
        if (!selectedAgency) {
            categorySelect.disabled = true;
            return;
        }
        categorySelect.disabled = false;
        const categoriesToShow = [...new Set(tableData.filter(item => item.agency === selectedAgency).map(item => item.category))].sort();
        
        categoriesToShow.forEach(category => {
            const option = document.createElement('option');
            option.value = category;
            option.textContent = category;
            if (category === currentCategory) {
                option.selected = true;
            }
            categorySelect.appendChild(option);
        });
    }

    // --- FUNCIONES DE RENDERIZADO ---
    function renderDefaultTableView() {
        tableBody.innerHTML = '';
        agencies.forEach((agency) => {
            const colors = agencyColors[agency] || { text: 'text-gray-800', bg: 'bg-white', border: 'border-gray-200' };
            const agencyRows = tableData.filter(row => row.agency === agency);
            
            agencyRows.forEach((rowData, rowIndex) => {
                const dataRow = document.createElement('tr');
                dataRow.style.backgroundColor = colors.bg;
                dataRow.style.borderBottom = `1px solid ${colors.border}`;

                let firstCell = '';
                if (rowIndex === 0) {
                    firstCell = `<td class="px-4 py-4 font-bold" style="color: ${colors.text};" rowspan="${agencyRows.length}">${agency}</td>`;
                }
                
                let cells = `<td class="px-4 py-4 font-medium text-gray-900 whitespace-nowrap">${rowData.category}</td>`;
                providers.forEach(provider => {
                    const priceText = rowData.prices[provider] || '-';
                    cells += `<td class="px-4 py-4 text-center font-medium" style="color: ${colors.text};">${priceText}</td>`;
                });
                
                dataRow.innerHTML = firstCell + cells;
                tableBody.appendChild(dataRow);
            });
        });
    }

    function renderComparisonView() {
        const baseAgency = agencySelect.value;
        const selectedCategory = categorySelect.value;

        if (!selectedCategory) {
            renderDefaultTableView();
            return;
        }
        
        tableBody.innerHTML = '';
        const baseRowData = tableData.find(r => r.agency === baseAgency && r.category === selectedCategory);
        let basePrice = null;
        let baseProvider = null;

        if(baseRowData) {
            for (const provider of providers) {
                basePrice = parsePrice(baseRowData.prices[provider]);
                if (basePrice !== null) {
                    baseProvider = provider;
                    break;
                }
            }
        }

        agencies.forEach((agency) => {
            const colors = agencyColors[agency] || { text: 'text-gray-800', bg: 'bg-white', border: 'border-gray-200' };
            const rowData = tableData.find(d => d.agency === agency && d.category === selectedCategory);
            
            const dataRow = document.createElement('tr');
            dataRow.style.backgroundColor = colors.bg;
            dataRow.style.borderBottom = `1px solid ${colors.border}`;

            dataRow.innerHTML = `<td class="px-4 py-4 font-bold" style="color: ${colors.text};">${agency}</td><td class="px-4 py-4 font-medium text-gray-900 whitespace-nowrap">${selectedCategory}</td>`;

            if (rowData) {
                providers.forEach(provider => {
                    const priceText = rowData.prices[provider] || '-';
                    const cell = document.createElement('td');
                    cell.className = 'px-4 py-4 price-cell';
                    cell.style.color = colors.text;
                    
                    const currentPrice = parsePrice(priceText);

                    if (basePrice !== null && currentPrice !== null) {
                         if(rowData.agency === baseAgency && provider === baseProvider){
                             cell.classList.add('base-price');
                         }
                        const percentage = ((currentPrice - basePrice) / basePrice) * 100;
                        const percentageDiv = document.createElement('div');
                        percentageDiv.className = 'percentage-diff';
                        if (percentage > 0) {
                            percentageDiv.textContent = `+${percentage.toFixed(0)}%`;
                            percentageDiv.classList.add('bg-red-100', 'text-red-700');
                        } else {
                            percentageDiv.textContent = `${percentage.toFixed(0)}%`;
                            percentageDiv.classList.add('bg-green-100', 'text-green-700');
                        }
                        cell.prepend(percentageDiv);
                    } else if (currentPrice === null) {
                         cell.innerHTML = '<span class="text-xs text-orange-600 font-semibold p-2">No disponible</span>';
                    }

                    cell.innerHTML += `<span class="price-value">${priceText}</span>`;
                    dataRow.appendChild(cell);
                });
            } else {
                dataRow.innerHTML += `<td colspan="${providers.length}" class="px-4 py-4 text-center text-sm text-gray-500 italic">No tiene la categoría</td>`;
            }
            tableBody.appendChild(dataRow);
        });
    }
    
    function resetView() {
        agencySelect.value = '';
        categorySelect.value = '';
        categorySelect.disabled = true;
        renderDefaultTableView();
    }

    // --- INICIALIZACIÓN ---
    populateAgencyDropdown();
    populateCategoryDropdown();
    renderDefaultTableView();
    
    agencySelect.addEventListener('change', (e) => {
        populateCategoryDropdown(e.target.value);
        if(categorySelect.value){
            renderComparisonView();
        } else {
            renderDefaultTableView();
        }
    });
    categorySelect.addEventListener('change', renderComparisonView);
    resetButton.addEventListener('click', resetView);
});
</script>

</body>
</html>

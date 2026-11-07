const _months = ['jan', 'fev', 'mar', 'abr', 'mai', 'jun', 'jul', 'ago', 'set', 'out', 'nov', 'dez'];

/// "6 nov 2025"
String formatDate(DateTime d) => '${d.day} ${_months[d.month - 1]} ${d.year}';

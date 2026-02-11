class DateFormatter {
  static String shortPtBr(DateTime d) {
    const week = ['Dom', 'Seg', 'Ter', 'Qua', 'Qui', 'Sex', 'Sáb'];
    const month = [
      'Jan', 'Fev', 'Mar', 'Abr', 'Mai', 'Jun',
      'Jul', 'Ago', 'Set', 'Out', 'Nov', 'Dez',
    ];

    return '${week[d.weekday % 7]}, '
        '${d.day.toString().padLeft(2, '0')} '
        '${month[d.month - 1]}';
  }
}

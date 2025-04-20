class AppConfig {
  static const bool isProduction = true; // Altere para true quando publicar

  static String get baseUrl {
    if (isProduction) {
      return 'https://ebenezerprodapwin-dyc3eqfrfmdghfbf.centralus-01.azurewebsites.net';
    } else {
      return 'http://192.168.1.35:7125';
    }
  }
}

import '../models/bnbprice_model.dart';
import '../models/tokenprice_m.dart';
import 'services.dart';

Future<double> getBnbPriceApi() async {
  String _url = 'https://api.bscscan.com/api?module=stats&action=bnbprice&apikey=NUK56EKJ4MJDZ3AV3K934UDS425YA52FIY';
  var network = NetworkHttp(_url);
  String str = await network.getDataPost();
  // print('RawJSON $str');
  if (str != '') {
    BnbPriceModel bnbPriceOject = bnbPriceFromJson(str);
    // print('ethusd ${bnbPriceOject.result!.ethusd}');
    return bnbPriceOject.priceOj!.bnbusd!;
  } else {
    return 0;
  }
}

Future<TokenPricePk> getTokenPricePanecakeApi({required String symbol}) async {
  // String animalToken = '0x744D10b0D2333fF68f46d406E1187cb32C3b7C47';
  // String dot = '0x7083609fCE4d1d8Dc0C979AAb8c869Ea2C873402';
  // String shiba = '0x2859e4544C4bB03966803b044A93563Bd2D0DD4D';
  // String poly = '0xcc42724c6683b7e57334c4e856f4c9965ed682bd';
  // String celo = '';

  String token = '';
  if (symbol == 'DOT') {
    token = '0x7083609fCE4d1d8Dc0C979AAb8c869Ea2C873402';
  } else if (symbol == 'POLYGON') {
    token = '0xcc42724c6683b7e57334c4e856f4c9965ed682bd';
  } else if (symbol == 'SHIBA') {
    token = '0x2859e4544C4bB03966803b044A93563Bd2D0DD4D';
  } else if (symbol == 'ADA') {
    token = '0x3ee2200efb3400fabb9aacf31297cbdd1d435d47';
  } else {
    '';
  }
  if (token.isNotEmpty) {
    String _url = 'https://api.pancakeswap.info/api/v2/tokens/$token';
    var network = NetworkHttp(_url);
    String str = await network.getDataJson();
    // print('RawJSON $str');
    if (str != '') {
      TokenPricePk priceOject = tokenPricePkFromJson(str);
      // print('priceUsd: ${priceOject.data!.price!}');
      return priceOject;
    } else {
      return TokenPricePk();
    }
  } else {
    return TokenPricePk();
  }
}

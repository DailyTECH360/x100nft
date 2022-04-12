String brandName = 'X100NFT';
String brandFull = 'X100NFT';
String slogan = 'X100NFT Platform';

String webLink = 'https://X100NFT.web.app';
String emailSupport = 'info@X100NFT.web.app';

String teleLinkGroup = 'https://t.me/AnimalLandOfficial';
// String teleLinkGroupTest = 'https://t.me/animatoken';
String teleLinkChannel = 'https://t.me/AnimalLandChannel';
String twitterLink = 'https://twitter.com/AnimalLandNFT';

String symbolAll = '\$';
String symbolUsdt = 'USDT';
String symbolVnd = 'VND';
String symbold = 'đ';
String chainUsdt = 'trc20';
String tokenChain = 'bsc';

//------------------------------------------------------------
String symbolToken = 'TLG';
String tokenName = 'TLG';
int tokenDecimal = 8;
int tokenTotalSupply = 1000000000000;
const tokenIcon = 'https://i.im.ge/2022/01/28/XiiXaP.png';

String symbolToken2 = 'TLG';

String scOwnerAddr = '0xB8017b0326eE097d86CBba6AFb731B9dDD56558B'.toLowerCase(); //'0x4f3518d0edd615281c730d175404d2a6bdd4f038';
const scToken = '0x744D10b0D2333fF68f46d406E1187cb32C3b7C47'; // '0x0fCd882F40117A41D4dc2B6229F63cb639ee3229';
const scTokenTestNET = '0x0fCd882F40117A41D4dc2B6229F63cb639ee3229';

//---------------------------- THÔNG TIN VÍ TỔNG NHẬN:
// const masterAddrGetBnbUsdt = '0x31B140A72E8E652fF7F9A501e30388986c86F6A9';
//'0xE10C4ab6F91e0CDd39Ad559a90513752AD5A1405';// Ví nhận cũ
//---------------------------- THÔNG TIN VÍ TỔNG Contract  ĐỂ TRẢ USDT CHO KHÁCH:
// const masterAddrPayUsdt = '0x3dA8D4Fb5B94B846F09Ae1522a99C70AbcF5E3b9';
// Client đùng để check số dư trước khi chạy Func
//----------------------------
const scUsdtBep20Addr = '0x55d398326f99059ff775485246999027b3197955';
const scUsdtTrc20Addr = 'TR7NHqjeKQxGTCi8q8ZY4pL8otSzgjLj6t';
//----------------------------

BigInt wei18 = BigInt.from(1000000000000000000);
BigInt wei8 = BigInt.from(100000000);

String scanLink = 'https://bscscan.com';
String bscscanLink = 'https://bscscan.com/token';
String scanLinkTest = 'https://testnet.bscscan.com';
String scTokenAddr({required int chainId}) {
  return chainId == 56
      ? scToken
      : chainId == 97
          ? scTokenTestNET
          : scToken;
}

String scanWebLink({required int chainId}) {
  return chainId == 56
      ? scanLink
      : chainId == 97
          ? scanLinkTest
          : '';
}

String addrBscSwithLink({required int chainId, required String addr}) {
  return '${scanWebLink(chainId: chainId)}/address/$addr';
}

String scTokenBscSwithLink({required int chainId}) {
  return '${scanWebLink(chainId: chainId)}/token/${scTokenAddr(chainId: chainId)}';
}

String get scTokenLink => tokenChain == 'tron' ? '$tronscanLink/$scToken' : '$bscscanLink/$scToken';
String get scanLogo => tokenChain == 'tron' ? 'assets/crypto/tronscan.png' : 'assets/crypto/bscscan_logo192.png';
String get scanName => tokenChain == 'tron' ? 'Tronscan' : 'Bscscan';

//---------------------------- TRON
String tronscanLink = 'https://tronscan.org/#/token20';
String tronscanLinkTransaction = 'https://tronscan.org/#/transaction';
String scUsdtTrcLink = '$tronscanLink/$scUsdtTrc20Addr';

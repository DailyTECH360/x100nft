import * as admin from 'firebase-admin';
import * as functions from 'firebase-functions';

global.fetch = require('node-fetch');
var Web3 = require("web3"); // npm i web3
const web3 = new Web3("https://bsc-dataseed1.binance.org:443"); // mainnet
// const web3 = new Web3('https://data-seed-prebsc-1-s2.binance.org:8545'); // testnet
// import * as https from 'https';
// import { BigBatch } from '@qualdesk/firestore-big-batch';
// import { generateAccount } from 'tron-create-address'

admin.initializeApp();
const db = admin.firestore();
const timeMax9p = { timeoutSeconds: 540, memory: '1GB' as const }; // 1GB memory: '2GB' as const,
const time360 = { timeoutSeconds: 360, memory: '512MB' as const };
const time300 = { timeoutSeconds: 300, memory: '512MB' as const };


// const brandName = 'x100nft';

// const oneDmilis = 86400000;
// const oneHmilis = 3600000;
// const oneSmilis = 1000;
// const oneMmilis = 60 * oneSmilis;

// firebase deploy --only functions
// firebase deploy --only firestore:indexes
// firebase deploy --only firestore:rules
// ---------------------------------------------------------------------//------------//--------
async function genAddrBEP20(coll: string, uidClient: string): Promise<string> {
    try {
        const json = await web3.eth.accounts.create();
        await db.collection('keys').doc(json.address).set({
            "uidClient": uidClient,
            "address": json.address,
            "chain": 'BEP20',
            "privateKey": json.privateKey,
            "timeCreated": admin.firestore.Timestamp.now(),
        }, { merge: true }).catch(err => console.log("ERROR: " + err));

        // await db.collection("keys").add({});
        await db.collection(coll).doc(uidClient).set({ "addrDepBep": json.address }, { merge: true }).catch(err => console.log("ERROR: " + err));
        console.log(uidClient, ': generateAddressBEP: DONE!', json.address);
        return json.address;
    } catch (e) {
        console.log(uidClient, ': generateAddressBEP:', e);
        return '';
    };
};

async function scanBNBDep(uidColl: string, uidClient: string, address: string, tokenName: string, numRun: number) {
    console.log(uidClient, 'Check DepBNB:', address);
    try {
        // Get Dep BNB list:
        // https://api.bscscan.com/api?module=account&action=txlist&address=0x9AFF161C1DB86522BE1F8BE30AF2fe05B75F4301&sort=desc&apikey=NUK56EKJ4MJDZ3AV3K934UDS425YA52FIY
        const _url: string = 'https://api.bscscan.com/api?module=account&sort=desc&action=txlist';
        const apikey: string = 'NUK56EKJ4MJDZ3AV3K934UDS425YA52FIY';
        const addressOk = address.toLowerCase();
        console.log('addressOk:', addressOk);
        let response = await fetch(`${_url}&address=${addressOk}&apikey=${apikey}`);
        const json = await response.json();
        // console.log('json:', json);

        const depList: Array<any> = json.result;
        console.log('All List:', depList.length);

        if (depList.length > 0) {
            depList.forEach(async (e: any) => {
                const tokenDecimal: number = 18;
                const amount: number = Number(e.value!) / (10 ** tokenDecimal);
                const status: string = e.txreceipt_status ?? '';
                if (e.to === addressOk && status === '1' && amount > 0) {
                    console.log(`Deposit BNB = ${amount}`);

                    await db.collection("deposits").doc(e.hash).set({
                        // 'project': proId,
                        'uidClient': uidClient,
                        'uidColl': uidColl,
                        // 'webhook': webhook,
                        'from': e.from ?? '',
                        'to': e.to ?? '',
                        'status': 1,
                        'amount': amount,
                        'txhash': e.hash ?? '',
                        'timestamp': Number(e.timeStamp ?? '0') * 1000,
                        'tokenName': 'BNB',
                        'tokenSymbol': 'BNB',
                        'nonce': e.nonce ?? '',
                        'blockHash': e.blockHash ?? '',
                        'blockNumber': e.blockNumber ?? '',
                        'transactionIndex': e.transactionIndex ?? '',
                        'gas': e.gas ?? '',
                        'gasPrice': e.gasPrice ?? '',
                        'gasUsed': e.gasUsed ?? '',
                        'cumulativeGasUsed': e.cumulativeGasUsed ?? '',
                        'confirmations': e.confirmations ?? '',
                    }, { merge: true }).catch(err => console.log("ERROR: " + err));
                    console.log(uidClient, ': Deposits BNB DONE! - ', addressOk);
                };
            });
        };
    } catch (e) {
        console.log(uidClient, ': Get DepBNB:', e);
    };
    numRun--
    if (numRun > 0) {
        setTimeout(() => {
            console.log('120s: RunNEXT:', numRun);
            scanBNBDep(uidColl, uidClient, address, tokenName, numRun);
        }, 120000);
    }
};
async function scanTokenDepBEP20(uidColl: string, uidClient: string, address: string, tokenName: string, numRun: number) {
    console.log(uidClient, 'Check DepBEP20:', address);
    try {
        // https://api.bscscan.com/api?module=account&action=tokentx&address=0x3b9af5ac0e91d92ae3d30637d1434b4d2f847bc8&apikey=NUK56EKJ4MJDZ3AV3K934UDS425YA52FIY
        // https://api.bscscan.com/api?module=account&action=tokentx&address=0x16b9a82891338f9ba80e2d6970fdda79d1eb0dae&apikey=NUK56EKJ4MJDZ3AV3K934UDS425YA52FIY
        const _url: string = 'https://api.bscscan.com/api?module=account&action=tokentx';
        const apikey: string = 'NUK56EKJ4MJDZ3AV3K934UDS425YA52FIY';
        const addressOk = address.toLowerCase();
        console.log('addressOk:', addressOk);
        let response = await fetch(`${_url}&address=${addressOk}&apikey=${apikey}`);
        const json = await response.json();
        // console.log('json:', json);

        const depList: Array<any> = json.result;
        console.log('DepBEP20 List:', depList.length);

        if (depList.length > 0) {
            depList.forEach(async (e: any) => {
                const tokenDecimal: number = Number(e.tokenDecimal);
                const amount: number = Number(e.value!) / (10 ** tokenDecimal);

                if (e.to === address && e.tokenName === tokenName && amount > 0) {
                    console.log(`Deposit: ${e.tokenName} = ${amount}`);
                    await db.collection("deposits").doc(e.hash).set({
                        // 'project': proId,
                        'uidClient': uidClient,
                        'uidColl': uidColl,
                        // 'webhook': webhook,
                        'from': e.from ?? '',
                        'to': e.to ?? '',
                        'amount': amount,
                        'txhash': e.hash ?? '',
                        'status': 1,
                        // 'timeConfirm': admin.firestore.Timestamp.fromMillis(Number(e.timeStamp!)),
                        'timestamp': Number(e.timeStamp ?? '0') * 1000,
                        'blockNumber': e.blockNumber ?? '',
                        'nonce': e.nonce ?? '',
                        'blockHash': e.blockHash ?? '',
                        'contractAddress': e.contractAddress ?? '',
                        'tokenName': e.tokenName ?? '',
                        'tokenSymbol': e.tokenSymbol ?? '',
                        'tokenDecimal': e.tokenDecimal ?? '',
                        'transactionIndex': e.transactionIndex ?? '',
                        'gas': e.gas ?? '',
                        'gasPrice': e.gasPrice ?? '',
                        'gasUsed': e.gasUsed ?? '',
                        'cumulativeGasUsed': e.cumulativeGasUsed ?? '',
                        'input': e.input ?? '',
                        'confirmations': e.confirmations ?? '',
                    }, { merge: true }).catch(err => console.log("ERROR: " + err));
                    console.log(uidClient, ': Deposits BEP20 DONE! - ', address);
                };
            });
        };
    } catch (e) {
        console.log(uidClient, ': Get Dep BEP20:', e);
    };
    numRun--
    if (numRun > 0) {
        setTimeout(() => {
            console.log('120s: RunNEXT:', numRun);
            scanTokenDepBEP20(uidColl, uidClient, address, tokenName, numRun);
        }, 120000);
    }
};

async function depSave(amount: number, uidClient: string, name: string, address: string, tokenSymbol: string, w: string, depId: string) {
    // Ghi vao ls giao dich
    const note: string = `Deposit by ${tokenSymbol}`;
    await db.collection('t').add({
        amount: amount,
        fee: 0,
        rate: 0,
        status: 'done',
        type: 'Deposit',
        note: note,
        symbol: tokenSymbol,
        wallet: w,
        name: name,
        uUid: uidClient,
        uOtherUid: address,
        uOtherName: address,
        timeMilis: admin.firestore.Timestamp.now().toMillis(),
    }).then(() => {
        db.collection('deposits').doc(depId).set({ saveW: true }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
    }).catch((err) => console.log("ERROR: " + err));
}
export const depCreate = functions.region('asia-east2').firestore.document('deposits/{id}').onCreate(async (snap, context) => {
    const id = context.params.id;
    const depData = snap.data();
    const uidClient: string = depData.uidClient ?? '';
    const tokenName: string = depData.tokenName ?? '';
    const tokenSymbol: string = depData.tokenSymbol ?? 'BNB';

    const address: string = depData.to ?? '';
    const txhash: string = depData.txhash ?? '';
    const amount: number = depData.amount ?? 0;
    const status: number = depData.status ?? 0;

    let name: string = '';
    const snapUser: any = await db.collection('users').doc(uidClient).get(); // console.log(JSON.stringify(snapUser.data()))
    if (snapUser.exists) {
        name = snapUser.data().name ?? '';
        const email: string = snapUser.data().email ?? '';
        const phone: string = snapUser.data().phone ?? '';
        await db.collection('deposits').doc(id).set({
            name: name,
            phone: phone,
            email: email,
        }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
    }

    if (txhash != '' && id === txhash && amount > 0 && status === 1) {
        // collectUser(address, id);
        if (tokenName === 'Binance-Peg BSC-USD' && tokenSymbol !== 'BNB') {
            depSave(amount, uidClient, name, address, tokenSymbol, 'wUsd', id).then(async () => {
                await db.collection("users").doc(uidClient).set({
                    'wUsd': admin.firestore.FieldValue.increment(amount),
                    'totalDepUsdtBep20': admin.firestore.FieldValue.increment(amount),
                }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
            }).catch((err) => console.log("ERROR: " + err));
        } else if (tokenSymbol === 'BNB') {
            depSave(amount, uidClient, name, address, tokenSymbol, 'wBnb', id).then(async () => {
                await db.collection("users").doc(uidClient).set({
                    'wBnb': admin.firestore.FieldValue.increment(amount),
                    'totalDepBnb': admin.firestore.FieldValue.increment(amount),
                }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
            }).catch((err) => console.log("ERROR: " + err));
        }
    }
});
export const depUpdate = functions.region('asia-east2').firestore.document('deposits/{id}').onUpdate(async (change, context) => {
    const id = context.params.id;
    const depDataOld = change.before.data();
    const depData = change.after.data();

    const name: string = depData.name ?? '';
    const uidClient: string = depData.uidClient ?? '';
    const tokenName: string = depData.tokenName ?? '';
    const tokenSymbol: string = depData.tokenSymbol ?? 'BNB';
    const address: string = depData.to ?? '';
    const txhash: string = depData.txhash ?? '';
    const amount: number = depData.amount ?? 0;
    const statusOld: number = depDataOld.status ?? 0;
    const status: number = depData.status ?? 0;
    if (txhash != '' && id === txhash && amount > 0 && status != statusOld && status === 1) {
        // collectUser(address, id);
        if (tokenName === 'Binance-Peg BSC-USD' && tokenSymbol !== 'BNB') {
            depSave(amount, uidClient, name, address, tokenSymbol, 'wUsd', id).then(async () => {
                await db.collection("users").doc(uidClient).set({
                    'wUsd': admin.firestore.FieldValue.increment(amount),
                    'totalDepUsdtBep20': admin.firestore.FieldValue.increment(amount),
                }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
            }).catch((err) => console.log("ERROR: " + err));
        } else if (tokenSymbol === 'BNB') {
            depSave(amount, uidClient, name, address, tokenSymbol, 'wBnb', id).then(async () => {
                await db.collection("users").doc(uidClient).set({
                    'wBnb': admin.firestore.FieldValue.increment(amount),
                    'totalDepUsdtBnb': admin.firestore.FieldValue.increment(amount),
                }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
            }).catch((err) => console.log("ERROR: " + err));
        }
    }
});
// -----------------------------------------



async function updateAny(coll: string, docid: string, data: {}) {
    if (coll !== '' && docid !== '' && data !== null) {
        return await db.collection(coll).doc(docid).set(data, { merge: true }).then(() => {
            console.log(coll, docid, 'updateDB Done')
        }).catch((err) => console.log('ERROR: ' + err));
    } else {
        return null;
    }
}
async function saveAny(coll: string, docid: string, key: string, amount: number) {
    if (docid.length > 0 && coll.length > 0) {
        try {
            // let newValue: number = amount; if (newValue < 0) newValue = 0;
            var obj = <any>{};
            obj[key] = admin.firestore.FieldValue.increment(amount);
            await db.collection(coll).doc(docid).set(obj, { merge: true }).catch((err) => console.log("ERROR: " + err));
            console.log('Save Done:', amount, docid, coll);
        } catch (e) {
            console.log('SaveAny failure:', e);
        }
    } else {
        console.log('Coll, Docid Not Ok:', docid, coll);
    }
}
// function getTimeByZone(zone: number): Date {
//     const nowMilis = admin.firestore.Timestamp.now().toMillis() + zone * oneHmilis;
//     const nowDate = admin.firestore.Timestamp.fromMillis(nowMilis).toDate();
//     // console.log('AdminTime', admin.firestore.Timestamp.now().toDate())
//     // console.log('VN', nowDateVN);
//     return nowDate;
// }

async function notiFunc(uid: string, uDataNew: any, mes: string,) {
    const notiPhone = {
        title: 'Member',
        content: mes,
        read: false,
        uid: uDataNew.uidSpon ?? '',
        fromUid: uid,
        fromName: uDataNew.name ?? '',
        fromPhone: uDataNew.phone ?? '',
        timeCreated: admin.firestore.Timestamp.now(),
        t: (uDataNew.role ?? '') == 'dev' || (uDataNew.role ?? '') == 'T' ? true : false,
    }
    const notiEmail = {
        title: 'Member',
        content: mes,
        read: false,
        uid: uDataNew.uidSpon ?? '',
        fromUid: uid,
        fromName: uDataNew.name ?? '',
        fromEmail: uDataNew.email ?? '',
        timeCreated: admin.firestore.Timestamp.now(),
        t: (uDataNew.role ?? '') == 'dev' || (uDataNew.role ?? '') == 'T' ? true : false,
    }
    return await db.collection('notices').add(uDataNew.phone == '' ? notiEmail : notiPhone).then(() => {
        console.log('Success - Noti to : ' + (uDataNew.uidSpon ?? ''));
    }).catch((err) => console.log('ERROR: ' + err));
}
// ------------HAM GEN UPlist TRUC HE: OK
async function gen_upLine(uidMain: string, spon: string) {
    const refUserMain = db.collection('users').doc(uidMain);
    // Ghi luôn vào UserMain vì khi sự kiện User sảy ra đã lấy được Data của UserMain
    await refUserMain.update({ upLine: admin.firestore.FieldValue.arrayUnion(spon) });
    saveAny('users', spon, 'teamGen', 1); // Cộng thêm vào tổng team cho spon;
    // Goi sponData(user)
    const snapUser: any = await db.collection('users').doc(spon).get(); // console.log(JSON.stringify(snapUser.data()))
    if (snapUser.exists) {
        const uidSpon: string = snapUser.data().uidSpon ?? '';
        if (uidSpon.length > 10) {
            await gen_upLine(uidMain, uidSpon).catch((err) => console.log('ERROR: ' + err)); // Nếu ko gặp TOP thì lên tiếp - Mỗi bậc lại chạy hàm đệ quy để lên
        } else {
            console.log('Gen UpLine Done for: ' + uidMain);
        }
    }
}
// --- SỰ KIỆN: XOÁ USER_AUTH
export const uAuthDelete = functions.region('asia-east2').auth.user().onDelete(async (user) => {
    console.log('UserAuth deleted is done! ', user.uid, 'Phone: ', user.phoneNumber ?? '+xxx');
    // Get User Data:
    const uidRef = db.collection('users').doc(user.uid);
    const uSnap: any = await uidRef.get().catch((error) => console.log('Error get userData :', error));
    const uidSpon: string = uSnap.data().uidSpon;
    const upLine: Array<string> = uSnap.data().upLine; // Nếu chưa có thì = undefined

    // Delete User Data:
    await uidRef.delete().then(async () => {
        console.log('UserData deleted is done! ', user.uid, 'Phone: ', user.phoneNumber ?? '+xxx');
    }).catch((error) => console.log('Error deleting uData :', error));

    saveAny('settings', 'set', 'totalUsers', -1);
    // Cộng trừ lên cho Sponsor:
    saveAny('users', uidSpon, 'teamF1', -1);
    // Trừ vào tổng team cho Upline;
    if (upLine !== undefined && upLine.length > 0) {
        for (var upUid of upLine) {
            if (upUid.length >= 6) {
                saveAny('users', upUid, 'teamGen', -1);
            }
        };
    }

});
export const uLogWallet = functions.region('asia-east2').firestore.document('users/{uid}').onUpdate(async (change, context) => {
    const uid: string = context.params.uid;
    const uDataOld = change.before.data();
    const uDataNew = change.after.data();

    const name: string = uDataNew.name ?? '';
    const phone: string = uDataNew.phone ?? '';
    const email: string = uDataNew.email ?? '';
    const role: string = uDataNew.role ?? '';
    //----------------------------------------------------------------------------

    // Ghi lại ls biến động của ví wUsd;
    const wUsdOld: number = uDataOld.wUsd ?? 0;
    const wUsd: number = uDataNew.wUsd ?? 0;
    if (wUsd !== wUsdOld) {
        console.log('logWallet RUN');
        const logPhone = {
            wUsdNew: wUsd,
            wUsdOld: wUsdOld,
            wPs: (wUsd - wUsdOld),
            uid: uid,
            name: name,
            phone: phone,
            timeCreated: admin.firestore.Timestamp.now(),
            wallet: 'wUsd',
            t: role == 'dev' || role == 'T' ? true : false,
        }
        const logEmail = {
            wUsdNew: wUsd,
            wUsdOld: wUsdOld,
            wPs: (wUsd - wUsdOld),
            uid: uid,
            name: name,
            email: email,
            timeCreated: admin.firestore.Timestamp.now(),
            wallet: 'wUsd',
            t: role == 'dev' || role == 'T' ? true : false,
        }
        const data = (phone == '') ? logEmail : logPhone;
        return await db.collection('logWallet').add(data).catch((err) => console.log('ERROR: ' + err));
    }
});
export const uCreate = functions.region('asia-east2').runWith(time300).firestore.document('users/{id}').onCreate(async (snap, context) => {
    return saveAny('settings', 'set', 'totalUsers', 1);
});
export const uUpdate = functions.region('asia-east2').runWith(timeMax9p).firestore.document('users/{uid}').onUpdate(async (change, context) => {
    const uid: string = context.params.uid;
    const uDataOld = change.before.data();
    const uDataNew = change.after.data();
    const name: string = uDataNew.name ?? '';
    const upLine: Array<string> = uDataNew.upLine ?? []; // Nếu chưa có thì = undefined
    //----------------------------------------------------------------------------

    // Address Gen LATE
    const addrDepBepOld: string = uDataOld.addrDepBep ?? '';
    const addrDepBep: string = uDataNew.addrDepBep ?? '';
    if (addrDepBep.length < 10 && addrDepBep !== addrDepBepOld) {
        console.log('Address Gen LATE RUN');
        await genAddrBEP20('users', uid);
    }

    // Deposit
    const depCallBepOld: string = uDataOld.depCallBep ?? '';
    const depCallBep: string = uDataNew.depCallBep ?? '';
    const symbol: string = depCallBep.split('_')[0] ?? '';
    if (depCallBep !== depCallBepOld) {
        if (symbol === 'BNB') {
            await scanBNBDep('users', uid, addrDepBep, symbol, 5);
        } else {
            await scanTokenDepBEP20('users', uid, addrDepBep, symbol, 5);
        }

    }

    // KHI GẮN SPONSOR:
    const uidSponOld: string = uDataOld.uidSpon ?? '';
    const uidSpon: string = uDataNew.uidSpon ?? '';
    if (uidSpon !== uidSponOld && uidSpon.length > 10) {
        await db.collection('users').doc(uid).update({ upLine: [] });
        await gen_upLine(uid, uidSpon).catch((err) => console.log('ERROR: ' + err)); //Gen UpLine
        console.log('Spon: ' + uidSpon + ' - have a member: ' + uid + 'PHONE: ' + name);
        // const type: string = '$/Join bonus from F';
        // refBonusUp(10, uid, phone, uidSpon, type).catch(err => console.log('ERROR: ' + err));
        await saveAny('users', uidSpon, 'teamF1', 1);

        const snapUser: any = await db.collection('users').doc(uidSpon).get(); // console.log(JSON.stringify(snapUser.data()))
        if (snapUser.exists) {
            const sponName: string = snapUser.data().name ?? '';
            const sponEmail: string = snapUser.data().email ?? '';
            const sponPhone: string = snapUser.data().phone ?? '';
            updateAny('users', uid, {
                'sponName': sponName,
                'sponEmail': sponEmail,
                'sponPhone': sponPhone,
            });
        }
        // Ghi vao ls Thông báo (notices)
        notiFunc(uid, uDataNew, 'You have a new member');
    }

    // KHI GỠ SPONSOR:
    if (uidSpon !== uidSponOld && uidSpon === '' && uidSponOld.length > 6) {
        // Cộng trừ lên cho Sponsor:
        await saveAny('users', uidSpon, 'teamF1', -1);
        // Trừ vào tổng team cho Upline;
        if (upLine !== undefined && upLine.length > 0) {
            for (var upUid of upLine) {
                if (upUid.length >= 6) {
                    saveAny('users', upUid, 'teamGen', -1);
                }
            };
        }
    }

    const comAgentOld: number = uDataOld.comAgent ?? 0;
    const comAgent: number = uDataNew.comAgent ?? 0;
    if (comAgent != comAgentOld) {
        const sponUser: any = await db.collection('users').doc(uidSpon).get(); // console.log(JSON.stringify(snapUser.data()))
        if (sponUser.exists) {
            const comAgentF1Max: number = sponUser.data().comAgentF1Max ?? 0;
            if (comAgent > comAgentF1Max) {
                updateAny('users', uidSpon, { 'comAgentF1Max': comAgent });
            }
        }
    }

    const typeOld: string = uDataOld.type ?? '';
    const type: string = uDataNew.type ?? '';
    if (type !== typeOld) {
        if (type === 'NO') {
            updateAny('users', uid, { 'lockTrans': true, 'lockWithdraw': true });
        } else {
            updateAny('users', uid, { 'lockTrans': false, 'lockWithdraw': false });
        }
    }
    //----------------------------------------------------------------------------
    return true;
});

// Volume of Team
export const uVolumeMeUp = functions.region('asia-east2').runWith(timeMax9p).firestore.document('users/{uid}').onUpdate(async (change, context) => {
    // const uid: string = context.params.uid;
    const uDataOld = change.before.data();
    const uDataNew = change.after.data();
    const upLine: Array<string> = uDataNew.upLine ?? []; // Nếu chưa có thì = undefined
    //----------------------------------------------------------------------------

    // CỘNG - TRỪ VÀO 'volumeTeam' cho Upline;
    // Chỉ cộng thêm > 0 vì mỗi tuần sẽ clear hết volumeMe & volumeTeam
    const volumeMeOld: number = uDataOld.volumeMe ?? 0;
    const volumeMe: number = uDataNew.volumeMe ?? 0;
    const volumeMePhatSinh: number = volumeMe - volumeMeOld;
    const type: string = uDataNew.type ?? '';
    if (type !== 'NO') {
        if (volumeMe !== volumeMeOld && volumeMePhatSinh !== 0 && upLine.length > 0 && uDataNew.uidSpon.length > 6) {
            for (var upUid of upLine) {
                if (upUid.length >= 6) {
                    saveAny('users', upUid, 'volumeTeam', volumeMePhatSinh);
                }
            };
        }
    }
    return true;
});

export const investCreate = functions.region('asia-east2').runWith(time300).firestore.document('lendings/{id}').onCreate(async (snap, context) => {
    // const id: string = context.params.id;
    const dataNew = snap.data();
    const uid: string = dataNew.uid ?? '';
    const amount: number = dataNew.amount ?? 0;
    const status: string = dataNew.status ?? '';
    const type: string = dataNew.type ?? '';
    const symbol: string = dataNew.symbol ?? '';
    if (amount > 0 && status === 'run') {
        saveAny('users', uid, `totalLendingNum${symbol}`, 1);
        saveAny('users', uid, `totalLending${symbol}`, amount);
    }
    if (type !== 'NO') {
        if (amount > 0) {
            if (status === 'run') {
                saveAny('settings', 'set', `totalLendingRun${symbol}`, 1);
                saveAny('settings', 'set', `totalLendingAmountRun${symbol}`, amount);
            }
            saveAny('settings', 'set', `totalLendingAmount${symbol}`, amount);
            saveAny('settings', 'set', `totalLending${symbol}`, 1);
        }
    }

    return true;
});
export const investUpdate = functions.region('asia-east2').runWith(time300).firestore.document('lendings/{id}').onUpdate(async (change, context) => {
    // const id: string = context.params.id;
    const dataOld = change.before.data();
    const dataNew = change.after.data();
    const uid: string = dataNew.uid ?? '';
    const amount: number = dataNew.amount ?? 0;
    const statusOld: string = dataOld.status ?? '';
    const status: string = dataNew.status ?? '';
    const type: string = dataNew.type ?? '';
    const symbol: string = dataNew.symbol ?? '';

    if (type !== 'NO') {
        if (status !== statusOld) {
            if (status === 'done') {
                saveAny('settings', 'set', `totalLendingDone${symbol}`, 1);
                saveAny('settings', 'set', `totalLendingAmountDone${symbol}`, amount);
            }
            if (status === 'stop') {
                saveAny('settings', 'set', `totalLendingStop${symbol}`, 1);
                saveAny('settings', 'set', `totalLendingAmountStop${symbol}`, amount);

                if (uid.length > 10 && amount > 0) {
                    await saveAny('users', uid, getWalletBySymbol(symbol), amount); // Back to wallet

                    // Ghi vao ls giao dich
                    await db.collection('t').add({
                        'amount': amount,
                        'fee': 0,
                        'rate': 0,
                        'status': 'done',
                        'type': 'Lending stop',
                        'note': `Back to wallet: ${amount} ${symbol}`,
                        'symbol': symbol,
                        'wallet': getWalletBySymbol(symbol),
                        'uUid': uid,
                        'uName': '',
                        'uOtherUid': '',
                        'uOtherName': '',
                        'timeMilis': admin.firestore.Timestamp.now().toMillis(),
                    }).catch(err => console.log("ERROR: " + err));
                }
            }
        }
    }
    return true;
});
export const investDelete = functions.region('asia-east2').runWith(time360).firestore.document('lendings/{id}').onDelete(async (snap, context) => {
    const dataNew = snap.data();
    const uid: string = dataNew.uid ?? '';
    const amount: number = dataNew.amount ?? 0;
    const status: string = dataNew.status ?? '';
    const type: string = dataNew.type ?? '';
    const symbol: string = dataNew.symbol ?? '';

    if (uid.length > 10 && amount > 0) {
        await saveAny('users', uid, `totalLendingNum${symbol}`, -1);
        await saveAny('users', uid, `totalLending${symbol}`, -amount);
        await saveAny('users', uid, getWalletBySymbol(symbol), amount); // Back to wallet

        // Ghi vao ls giao dich
        await db.collection('t').add({
            'amount': amount,
            'fee': 0,
            'rate': 0,
            'status': 'done',
            'type': 'Lending delete',
            'note': `Back to wallet: ${amount} ${symbol}`,
            'symbol': symbol,
            'wallet': getWalletBySymbol(symbol),
            'uUid': uid,
            'uName': '',
            'uOtherUid': '',
            'uOtherName': '',
            'timeMilis': admin.firestore.Timestamp.now().toMillis(),
        }).catch(err => console.log("ERROR: " + err));
    }

    if (type !== 'NO') {
        if (amount > 0) {
            if (status === 'run') {
                saveAny('settings', 'set', `totalLendingRun${symbol}`, -1);
                saveAny('settings', 'set', `totalLendingAmountRun${symbol}`, -amount);
            }
            if (status === 'done') {
                saveAny('settings', 'set', `totalLendingDone${symbol}`, -1);
                saveAny('settings', 'set', `totalLendingAmountDone${symbol}`, -amount);
            }
            saveAny('settings', 'set', `totalLendingAmount${symbol}`, -amount);
            saveAny('settings', 'set', `totalLending${symbol}`, -1);
        }
    }
    return true;
});

export const stakCreate = functions.region('asia-east2').runWith(time300).firestore.document('stakings/{id}').onCreate(async (snap, context) => {
    // const id: string = context.params.id;
    const dataNew = snap.data();
    const uid: string = dataNew.uid ?? '';
    const amount: number = dataNew.amount ?? 0;
    const rateSymbolUsd: number = dataNew.rateSymbolUsd ?? 0;
    const status: string = dataNew.status ?? '';
    const type: string = dataNew.type ?? '';
    const symbol: string = dataNew.symbol ?? '';

    if (amount > 0 && status === 'run') {
        saveAny('users', uid, `totalStakNum${symbol}`, 1);
        saveAny('users', uid, `totalStak${symbol}`, amount);
        saveAny('users', uid, 'totalStakToUsd', (amount * rateSymbolUsd));
    }
    if (type !== 'NO') {
        if (amount > 0) {
            if (status === 'run') {
                saveAny('settings', 'set', `totalStakRun${symbol}`, 1);
                saveAny('settings', 'set', `totalStakAmountRun${symbol}`, amount);
            }
            saveAny('settings', 'set', `totalStakAmount${symbol}`, amount);
            saveAny('settings', 'set', `totalStak${symbol}`, 1);
        }
    }
    return true;
});
export const stakUpdate = functions.region('asia-east2').runWith(time300).firestore.document('stakings/{id}').onUpdate(async (change, context) => {
    // const id: string = context.params.id;
    const dataOld = change.before.data();
    const dataNew = change.after.data();
    const uid: string = dataNew.uid ?? '';
    const amount: number = dataNew.amount ?? 0;
    const getDoneAmount: number = dataNew.getDoneAmount ?? 0;
    const statusOld: string = dataOld.status ?? '';
    const status: string = dataNew.status ?? '';
    const type: string = dataNew.type ?? '';
    const symbol: string = dataNew.symbol ?? '';

    if (type !== 'NO') {
        if (status !== statusOld) {
            if (status === 'done') {
                await saveAny('users', uid, getWalletBySymbol(symbol), (amount + getDoneAmount)); // Back to wallet
                // Ghi vao ls giao dich
                await db.collection('t').add({
                    'amount': (amount + getDoneAmount),
                    'fee': 0,
                    'rate': 0,
                    'status': 'done',
                    'type': 'Staking done',
                    'note': `Back to wallet: ${amount + getDoneAmount} ${symbol}`,
                    'symbol': symbol,
                    'wallet': getWalletBySymbol(symbol),
                    'uUid': uid,
                    'uName': '',
                    'uOtherUid': '',
                    'uOtherName': '',
                    'timeMilis': admin.firestore.Timestamp.now().toMillis(),
                }).catch(err => console.log("ERROR: " + err));

                saveAny('settings', 'set', `totalStakDone${symbol}`, 1);
                saveAny('settings', 'set', `totalStakAmountDone${symbol}`, (amount));

            }
            if (status === 'stop') {
                saveAny('settings', 'set', `totalStakStop${symbol}`, 1);
                saveAny('settings', 'set', `totalStakAmountStop${symbol}`, amount);

                if (uid.length > 10 && amount > 0) {
                    await saveAny('users', uid, getWalletBySymbol(symbol), (amount + getDoneAmount)); // Back to wallet

                    // Ghi vao ls giao dich
                    await db.collection('t').add({
                        'amount': (amount + getDoneAmount),
                        'fee': 0,
                        'rate': 0,
                        'status': 'done',
                        'type': 'Staking stop',
                        'note': `Back to wallet: ${(amount + getDoneAmount)} ${symbol}`,
                        'symbol': symbol,
                        'wallet': getWalletBySymbol(symbol),
                        'uUid': uid,
                        'uName': '',
                        'uOtherUid': '',
                        'uOtherName': '',
                        'timeMilis': admin.firestore.Timestamp.now().toMillis(),
                    }).catch(err => console.log("ERROR: " + err));
                }
            }
        }
    }
    return true;
});
export const stakDelete = functions.region('asia-east2').runWith(time360).firestore.document('stakings/{id}').onDelete(async (snap, context) => {
    const dataNew = snap.data();
    const uid: string = dataNew.uid ?? '';
    const amount: number = dataNew.amount ?? 0;
    const getDoneAmount: number = dataNew.getDoneAmount ?? 0;
    const rateSymbolUsd: number = dataNew.rateSymbolUsd ?? 0;
    const status: string = dataNew.status ?? '';
    const type: string = dataNew.type ?? '';
    const symbol: string = dataNew.symbol ?? '';

    if (uid.length > 10 && amount > 0) {
        await saveAny('users', uid, `totalStakNum${symbol}`, -1);
        await saveAny('users', uid, `totalStak${symbol}`, -amount);
        saveAny('users', uid, 'totalStakToUsd', -(amount * rateSymbolUsd));

        await saveAny('users', uid, getWalletBySymbol(symbol), (amount + getDoneAmount)); // Back to wallet

        // Ghi vao ls giao dich
        await db.collection('t').add({
            'amount': (amount + getDoneAmount),
            'fee': 0,
            'rate': 0,
            'status': 'done',
            'type': 'Staking delete',
            'note': `Back to wallet: ${(amount + getDoneAmount)} ${symbol}`,
            'symbol': symbol,
            'wallet': getWalletBySymbol(symbol),
            'uUid': uid,
            'uName': '',
            'uOtherUid': '',
            'uOtherName': '',
            'timeMilis': admin.firestore.Timestamp.now().toMillis(),
        }).catch(err => console.log("ERROR: " + err));
    }

    if (type !== 'NO') {
        if (amount > 0) {
            if (status === 'run') {
                saveAny('settings', 'set', `totalStakRun${symbol}`, -1);
                saveAny('settings', 'set', `totalStakAmountRun${symbol}`, -amount);
            }
            if (status === 'done') {
                saveAny('settings', 'set', `totalStakDone${symbol}`, -1);
                saveAny('settings', 'set', `totalStakAmountDone${symbol}`, -amount);
            }
            saveAny('settings', 'set', `totalStakAmount${symbol}`, -amount);
            saveAny('settings', 'set', `totalStak${symbol}`, -1);
        }
    }
    return true;
});


// COMMISSION:--------------------------------------------------------
export const comCreate = functions.region('asia-east2').runWith(time300).firestore.document('commissions/{id}').onCreate(async (snap, context) => {
    const id: string = context.params.id;
    const dataNew = snap.data();
    const uid: string = dataNew.uid ?? '';
    const amount: number = dataNew.amount ?? 0;
    const type: string = dataNew.type ?? '';
    const symbol: string = dataNew.symbol ?? '';
    if (type === 'Direct commission' && amount > 0) {
        await saveAny('users', uid, `wCom${symbol}`, amount).then(() => {
            db.collection('commissions').doc(id).set({ wSave: 'OK' }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
        });
        await saveAny('users', uid, `wComTotal${symbol}`, amount);
    }
    if (amount > 0) {
        const typeU: string = dataNew.typeU ?? '';
        if (typeU !== 'NO') {
            saveAny('settings', 'set', `totalCom${symbol}`, 1);
            saveAny('settings', 'set', `totalComAmount${symbol}`, amount);
        }
    }
    return true;
});
export const comUpdate = functions.region('asia-east2').runWith(time300).firestore.document('commissions/{id}').onUpdate(async (change, context) => {
    const id: string = context.params.id;
    const dataOld = change.before.data();
    const dataNew = change.after.data();
    const uid: string = dataNew.uid ?? '';

    const type: string = dataNew.type ?? '';
    const symbol: string = dataNew.symbol ?? '';
    const amount: number = dataNew.amount ?? 0;

    const reSaveOld: string = dataOld.reSave ?? '';
    const reSave: string = dataNew.reSave ?? '';
    const wSave: string = dataNew.wSave ?? '';
    if (uid.length >= 6 && reSave !== reSaveOld && reSave.length >= 3) {
        if (type === 'Direct commission' && amount > 0 && wSave === '') {
            await saveAny('users', uid, `wCom${symbol}`, amount).then(() => {
                db.collection('commissions').doc(id).set({ wSave: 'OK' }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
            });
            await saveAny('users', uid, `wComTotal${symbol}`, amount);
        }
    }
    return;
});
export const comDelete = functions.region('asia-east2').runWith(time360).firestore.document('commissions/{id}').onDelete(async (snap, context) => {
    const dataNew = snap.data();
    const uid: string = dataNew.uid ?? '';
    const amount: number = dataNew.amount ?? 0;
    const wSave: string = dataNew.wSave ?? '';
    const symbol: string = dataNew.symbol ?? '';
    console.log('comDelete - amount =', amount);
    // Ghi vào ví commission
    if (amount > 0 && wSave === 'OK') {
        try {
            await saveAny('users', uid, `wCom${symbol}`, -amount);
            await saveAny('users', uid, `wComTotal${symbol}`, -amount);
        } catch (e) {
            console.log('comDelete - Wallet failure:', e);
        }
    }
    if (amount > 0) {
        const typeU: string = dataNew.typeU ?? '';
        if (typeU !== 'NO') {
            saveAny('settings', 'set', `totalCom${symbol}`, -1);
            saveAny('settings', 'set', `totalComAmount${symbol}`, -amount);
        }
    }
    return;
});
//----------------------------------------------------------------------------


// CÁC CRONJOB ----------------------------------------------------------------
// CHẠY HÀNG NGÀY - T7,CN - TÍNH LÃI 0 22 * * 1-5 “ Lúc 7 : 05 vào mọi ngày trong tuần từ Thứ Hai đến Thứ Sáu. ”
export const profitCreate = functions.region('asia-east2').runWith(timeMax9p).firestore.document('profits/{id}').onCreate(async (snap, context) => {
    const proId: string = context.params.id;
    const uDataNew = snap.data();
    const uid: string = uDataNew.uid ?? '';
    const name: string = uDataNew.name ?? '';
    const uidSpon: string = uDataNew.uidSpon ?? '';
    const comAgent: number = uDataNew.comAgent ?? 0;
    const getDoneDay: number = uDataNew.getDoneDay ?? 0;
    const symbol: string = uDataNew.symbol ?? '';

    const profitDay: number = uDataNew.profitDay ?? 0;
    const investId: string = uDataNew.investId ?? '';


    if (uid.length > 10 && profitDay > 0) {
        await saveAny('users', uid, getWalletBySymbol(symbol), profitDay).then(() => {
            // Save vào ví thành công;
            db.collection('profits').doc(proId).set({ 'wSave': true }, { merge: true }).catch(err => console.log("ERROR: " + err));
            console.log(uid, 'Save profits to wProfit Done!:', profitDay, investId);
        });
        await saveAny('users', uid, `wProfitTotal${symbol}`, profitDay);
    } else {
        console.log('Not run Profit Save W', profitDay, proId, investId, uid);
    }
    if (uid.length > 10 && uidSpon.length > 10 && profitDay > 0) {
        // TÍNH HH CỘNG HƯỞNG / LÃI TĨNH LÊN TRÊN:
        // Add ComAgent List
        const type: string = uDataNew.type ?? '';
        if (type !== 'NO') {
            const comAmountOk: number = (comAgent / 100) * profitDay;
            const note: string = `${comAgent}%/profit: ${comAmountOk.toFixed(2)} of F1}`;
            db.collection('commissions').add({
                amount: comAmountOk,
                gen: 1,
                type: 'Direct commission',
                note: note,
                fromVolume: profitDay,
                fromUid: uid,
                fromName: name,
                fromProid: proId,
                fromGetDay: getDoneDay,
                symbol: symbol,
                uid: uidSpon,
                timeCreated: admin.firestore.Timestamp.now(),
                wallet: getWalletBySymbol(symbol),
            }).then(() => {
                console.log('add Com his:', note);
            }).catch((err) => console.log('ERROR: ' + err));
        }
        db.collection('profits').doc(proId).set({ 'comRunning': true }, { merge: true }).catch(err => console.log("ERROR: " + err));
    }
    const type: string = uDataNew.type ?? '';
    if (type !== 'NO') {
        if (profitDay > 0) {
            saveAny('settings', 'set', `totalPro${symbol}`, 1);
            saveAny('settings', 'set', `totalProAmount${symbol}`, profitDay);
        }
    }
    return true;
});
export const profitDelete = functions.region('asia-east2').runWith(time360).firestore.document('profits/{id}').onDelete(async (snap, context) => {
    const proId: string = context.params.id;
    const uDataNew = snap.data();
    const uid: string = uDataNew.uid ?? '';

    const stakingId: string = uDataNew.stakingId ?? '';
    const profitDay: number = uDataNew.profitDay ?? 0;
    const symbol: string = uDataNew.symbol ?? '';

    if (uid.length > 10 && profitDay > 0) {
        await saveAny('users', uid, getWalletBySymbol(symbol), -profitDay)
        await saveAny('users', uid, `wProfitTotal${symbol}`, -profitDay);
    } else {
        console.log('Not run Profit Save W', profitDay, proId, stakingId, uid);
    }
    const type: string = uDataNew.type ?? '';
    if (type !== 'NO') {
        if (profitDay > 0) {
            saveAny('settings', 'set', `totalPro${symbol}`, -1);
            saveAny('settings', 'set', `totalProAmount${symbol}`, -profitDay);
        }
    }
    return true;
});

export const everyDayProfit = functions.region('asia-east2').runWith(time360).pubsub.schedule('05 1 * * *').timeZone('Asia/Saigon').onRun((context) => {
    (async () => {
        console.log("1h05 Asia timeZone Everyday RUN Profit", context.timestamp);
        const queryInvests = db.collection('lendings').where('status', '==', 'run'); //.where('status', '==', 'run')
        const arrInvests = await queryInvests.get().then((querySnapshot) => { return querySnapshot.docs.map((doc) => doc) });

        if (arrInvests.length > 0) {
            console.log("arrInvests = ", arrInvests.length);
            arrInvests.forEach(async (lendings) => {
                const getDoneDay: number = lendings.data().getDoneDay ?? 0;
                const getDoneDayNew: number = getDoneDay + 1;
                // const cycleDay: number = lendings.data().cycleDay ?? 0;
                const status: string = lendings.data().status ?? '';
                const type: string = lendings.data().type ?? '';

                if (status === 'run') {
                    const uid: string = lendings.data().uid ?? '';
                    const name: string = lendings.data().name ?? '';
                    const uidSpon: string = lendings.data().uidSpon ?? '';
                    const comAgent: number = lendings.data().comAgent ?? 0;
                    const rateD: number = lendings.data().rateD ?? 0;
                    const symbol: string = lendings.data().symbol ?? '';

                    const investAmount: number = lendings.data().amount ?? 0;
                    const profitDay: number = (rateD / 100) * investAmount;

                    // Ghi vi, tao ls gd;
                    await db.collection('profits').add({
                        'investId': lendings.id,
                        'investAmount': investAmount,
                        'profitDay': profitDay,
                        'rateD': rateD,
                        'getDoneDay': getDoneDayNew,
                        'uid': uid,
                        'name': name,
                        'uidSpon': uidSpon,
                        'comAgent': comAgent,
                        'wallet': getWalletBySymbol(symbol),
                        'symbol': symbol,
                        'timeCreated': admin.firestore.Timestamp.now(),
                        'type': type === 'NO' ? 'NO' : '',
                    }).then(async () => {
                        console.log(uid, '- add profits his done:', investAmount, lendings.id);
                        // Ghi them cong ngay;
                        db.collection('lendings').doc(lendings.id).set({
                            'getDoneDay': admin.firestore.FieldValue.increment(1),
                            'getDoneAmount': admin.firestore.FieldValue.increment(profitDay),
                        }, { merge: true }).catch(err => console.log("ERROR: " + err));

                        const timeMilis = admin.firestore.Timestamp.now().toMillis();
                        db.collection('lendings').doc(lendings.id).update({ 'listPro': admin.firestore.FieldValue.arrayUnion(`${getDoneDayNew}_${profitDay}_${timeMilis}`) });
                    }).catch(err => console.log("ERROR: " + err));
                    console.log(profitDay, "$ Profit from: ", lendings.id);
                }
                // else {
                //     db.collection('lendings').doc(lendings.id).set({ 'status': 'done' }, { merge: true }).catch(err => console.log("ERROR: " + err));
                // }
            });
        };
    })().catch(err => console.log("ERROR: " + err))
    return null;
});

export const everyDayProfitStak = functions.region('asia-east2').runWith(time360).pubsub.schedule('10 1 * * *').timeZone('Asia/Saigon').onRun((context) => {
    (async () => {
        console.log("1h10 Asia timeZone Everyday RUN ProfitStak", context.timestamp);
        const queryStakings = db.collection('stakings').where('status', '==', 'run'); //.where('status', '==', 'run')
        const arrStakings = await queryStakings.get().then((querySnapshot) => { return querySnapshot.docs.map((doc) => doc) });

        if (arrStakings.length > 0) {
            console.log("arrStakings = ", arrStakings.length);
            arrStakings.forEach(async (stak) => {
                const getDoneDay: number = stak.data().getDoneDay ?? 0;
                const getDoneDayNew: number = getDoneDay + 1;
                const cycleDay: number = stak.data().cycleDay ?? 0;
                const status: string = stak.data().status ?? '';
                const type: string = stak.data().type ?? '';

                if (status === 'run' && getDoneDay < cycleDay) {
                    const uid: string = stak.data().uid ?? '';
                    const name: string = stak.data().name ?? '';
                    const uidSpon: string = stak.data().uidSpon ?? '';
                    const comAgent: number = stak.data().comAgent ?? 0;
                    const rateD: number = stak.data().rateD ?? 0;
                    const symbol: string = stak.data().symbol ?? '';

                    const investAmount: number = stak.data().amount ?? 0;
                    const profitDay: number = (rateD / 100) * investAmount;

                    // Ghi vi, tao ls gd;
                    await db.collection('profitStak').add({
                        'stakId': stak.id,
                        'stakAmount': investAmount,
                        'profitDay': profitDay,
                        'rateD': rateD,
                        'getDoneDay': getDoneDayNew,
                        'uid': uid,
                        'name': name,
                        'uidSpon': uidSpon,
                        'comAgent': comAgent,
                        'wallet': getWalletBySymbol(symbol),
                        'symbol': symbol,
                        'timeCreated': admin.firestore.Timestamp.now(),
                        'type': type === 'NO' ? 'NO' : '',
                    }).then(async () => {
                        console.log(uid, '- add profitStak his done:', investAmount, stak.id);
                        // Ghi them cong ngay;
                        db.collection('stakings').doc(stak.id).set({
                            'getDoneDay': admin.firestore.FieldValue.increment(1),
                            'getDoneAmount': admin.firestore.FieldValue.increment(profitDay),
                        }, { merge: true }).catch(err => console.log("ERROR: " + err));

                        const timeMilis = admin.firestore.Timestamp.now().toMillis();
                        db.collection('stakings').doc(stak.id).update({ 'listPro': admin.firestore.FieldValue.arrayUnion(`${getDoneDayNew}_${profitDay}_${timeMilis}`) });
                    }).catch(err => console.log("ERROR: " + err));
                    console.log(profitDay, "$ Profit from: ", stak.id);
                }
                else {
                    db.collection('stakings').doc(stak.id).set({ 'status': 'done' }, { merge: true }).catch(err => console.log("ERROR: " + err));
                }
            });
        };
    })().catch(err => console.log("ERROR: " + err))
    return null;
});

function getWalletBySymbol(symbol: string) {
    if (symbol == 'USDT') {
        return 'wUsd';
    } else if (symbol == 'BNB') {
        return 'wBnb';
    } else if (symbol == 'DOT') {
        return 'wDot';
    } else if (symbol == 'POLYGON') {
        return 'wPoly';
    } else if (symbol == 'SHIBA') {
        return 'wShiba';
    } else if (symbol == 'CELO') {
        return 'wCelo';
    } else {
        return '';
    }
}

//---------------WITHDRAW:
export const wCreate = functions.region('asia-east2').runWith(time300).firestore.document('t/{id}').onCreate(async (snap, context) => {
    // const id: string = context.params.id;
    const dataNew = snap.data();

    const amount: number = dataNew.amount ?? 0;
    const fee: number = dataNew.fee ?? 0;

    // const uUid: string = dataNew.uUid ?? '';
    const uOtherUid: string = dataNew.uOtherUid ?? '';
    const status: string = dataNew.status ?? '';
    const type: string = dataNew.type ?? '';

    const amountDuong: number = amount < 0 ? (amount * -1) : amount;
    const amountTran: number = (amountDuong - (amountDuong * fee));

    if (type === 'Withdraw' && status === 'done') {
        if (uOtherUid.length > 10 && amountTran > 0) {
            // console.log('Withdraw Create uid:', uUid, 'address', uOtherUid, 'toUSD:', amountTran);
            db.collection('settings').doc('set').set({
                'totalWithdrawAmount': admin.firestore.FieldValue.increment(amountTran),
                'totalWithdraws': admin.firestore.FieldValue.increment(1)
            }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
        }
    }
    if (type === 'Withdraw' && status === 'pending') {
        if (uOtherUid.length > 10 && amountTran > 0) {
            // console.log('Withdraw Create uid:', uUid, 'address', uOtherUid, 'toUSD:', amountTran);
            db.collection('settings').doc('set').set({
                'totalWithdrawAmountPen': admin.firestore.FieldValue.increment(amountTran),
                'totalWithdrawsPen': admin.firestore.FieldValue.increment(1)
            }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
        }
    }
    return true;
});

export const wUpdate = functions.region('asia-east2').runWith(time300).firestore.document('t/{id}').onUpdate(async (change, context) => {
    // const id: string = context.params.id;
    const dataOld = change.before.data();
    const dataNew = change.after.data();

    const amount: number = dataNew.amount ?? 0;
    const fee: number = dataNew.fee ?? 0;
    const amountDuong: number = amount < 0 ? (amount * -1) : amount;
    const amountTran: number = (amountDuong - (amountDuong * fee));

    // const uUid: string = dataNew.uUid ?? '';
    const address: string = dataNew.uOtherUid ?? '';
    const statusOld: string = dataOld.status ?? '';
    const status: string = dataNew.status ?? '';
    const type: string = dataNew.type ?? '';

    if (type === 'Withdraw' && status === 'done' && statusOld === 'pending') {
        if (address.length > 10 && amountTran > 0) {
            // console.log('Withdraw Create uid:', uUid, 'address', uOtherUid, 'toUSD:', amountTran);
            db.collection('settings').doc('set').set({
                'totalWithdrawAmount': admin.firestore.FieldValue.increment(amountTran),
                'totalWithdraws': admin.firestore.FieldValue.increment(1)
            }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
        }
    }
    return;
});
export const wDelete = functions.region('asia-east2').runWith(time360).firestore.document('t/{id}').onDelete(async (snap, context) => {
    const dataNew = snap.data();

    const amount: number = dataNew.amount ?? 0;
    const amountDuong: number = amount < 0 ? amount * -1 : amount;

    const uUid: string = dataNew.uUid ?? '';
    const status: string = dataNew.status ?? '';
    const type: string = dataNew.type ?? '';
    if (type === 'Withdraw' && status === 'done' && uUid.length > 6) {
        db.collection('settings').doc('set').set({
            'totalWithdrawAmount': admin.firestore.FieldValue.increment(-amountDuong),
            'totalWithdraws': admin.firestore.FieldValue.increment(-1)
        }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
    }
    // Ghi vào ví commission
    if (type === 'Withdraw' && status === 'pending' && uUid.length > 6) {
        db.collection('users').doc(uUid).set({
            'wUsd': admin.firestore.FieldValue.increment(amountDuong)
        }, { merge: true }).catch((err) => console.log('ERROR: ' + err));

        db.collection('settings').doc('set').set({
            'totalWithdrawAmountPen': admin.firestore.FieldValue.increment(-amountDuong),
            'totalWithdrawsPen': admin.firestore.FieldValue.increment(-1)
        }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
    }
});
//----------------------------------------------------------------------------





// export const helloWorld = functions.https.onRequest((request, response) => {
//   functions.logger.info("Hello logs!", {structuredData: true});
//   response.send("Hello from Firebase!");
// });
export const deleUserOfTree = functions.region('asia-east2').runWith(timeMax9p).https.onRequest(async (req, res) => {
    console.log('Request iP: ' + req.ip);
    const uidTop: string = req.query.uid as string;
    console.log('Dele TopUser:', uidTop);
    if (uidTop !== undefined || uidTop !== '') {
        const uidList: Array<string> = await childGetListTotal2(uidTop);
        console.log('Dele users:', uidList.length, uidList);
        if (uidList.length > 0) {
            for (const uid of uidList) {
                await admin.auth().deleteUser(uid).then((deleteUsersResult) => {
                    console.log(`Successfully deleted ${deleteUsersResult} users`);
                }).catch((error) => { console.log('Error deleting users:', error) });
            }
        }
        res.status(200).send(`Dele Users: ${req.ip}, ${uidTop}`);
    } else { res.status(200).send(`No Users: ${uidTop}`) }
});

async function childGetListTotal2(topUid: string): Promise<string[]> {
    let listOfUid: Array<string> = [];

    const childListDocs = await db.collection('users').where('upLine', 'array-contains', topUid).get();
    if (childListDocs != null && childListDocs.docs != null && childListDocs.docs.length > 0) {
        for (var i = 0; i < childListDocs.docs.length; i++) {
            listOfUid.push(childListDocs.docs[i].id);
        }
    }
    return listOfUid;
}

export const clearTest = functions.region('asia-east2').runWith(time300).https.onRequest(async (request, response) => {
    console.log('Request iP: ' + request.ip);

    const logWalletQueryAll = db.collection('logWallet'); //.where('t', '==', true);
    const logWalletArr = await logWalletQueryAll.get().then((querySnapshot) => querySnapshot.docs.map((doc) => doc));
    if (logWalletArr.length > 0) {
        console.log('logWalletArr = ', logWalletArr.length);
        logWalletArr.forEach(async (e) => {
            await db.collection('logWallet').doc(e.id).delete().catch((err) => console.log('ERROR: ' + err));
        });
    }
    const queryAllCom = db.collection('commissions'); //.where('t', '==', true);
    const arrCom = await queryAllCom.get().then((querySnapshot) => querySnapshot.docs.map((doc) => doc));
    if (arrCom.length > 0) {
        console.log('arrCom_t = ', arrCom.length);
        arrCom.forEach(async (e) => {
            await db.collection('commissions').doc(e.id).delete().catch((err) => console.log('ERROR: ' + err));
        });
    }

    const queryAllT = db.collection('t'); //.where('t', '==', true);
    const arrT = await queryAllT.get().then((querySnapshot) => querySnapshot.docs.map((doc) => doc));
    if (arrT.length > 0) {
        console.log('arrgoPlayBetList = ', arrT.length);
        arrT.forEach(async (e) => {
            await db.collection('t').doc(e.id).delete().catch((err) => console.log('ERROR: ' + err));
        });
    }

    const queryAllinvests = db.collection('lendings'); //.where('t', '==', true);
    const arrInvest = await queryAllinvests.get().then((querySnapshot) => querySnapshot.docs.map((doc) => doc));
    if (arrInvest.length > 0) {
        console.log('lendings = ', arrInvest.length);
        arrInvest.forEach(async (e) => {
            await db.collection('lendings').doc(e.id).delete().catch((err) => console.log('ERROR: ' + err));
        });
    }

    const queryAllpro = db.collection('profits'); //.where('t', '==', true);
    const arrwPro = await queryAllpro.get().then((querySnapshot) => querySnapshot.docs.map((doc) => doc));
    if (arrwPro.length > 0) {
        console.log('profits = ', arrwPro.length);
        arrwPro.forEach(async (e) => {
            await db.collection('profits').doc(e.id).delete().catch((err) => console.log('ERROR: ' + err));
        });
    }

    const queryUser = db.collection('users'); // .where('role', '==', 'T');
    const arrUserTest = await queryUser.get().then((querySnapshot) => querySnapshot.docs.map((doc) => doc));
    console.log('Total users:', arrUserTest.length);
    if (arrUserTest.length > 0) {
        arrUserTest.forEach(async (user) => {
            await db.collection('users').doc(user.id).set({
                'volumeMe': 0, 'volumeTeam': 0, 'wUsd': 0, 'wCom': 0, 'wComTotal': 0, 'wProfitTotal': 0
            }, { merge: true }).catch((err) => console.log('ERROR: ' + err));
            // console.log(`${user.id}: Clear DONE!`);
        });
    }
    response.status(200).send(`${request.ip} -> Clear scan Done!`);
});

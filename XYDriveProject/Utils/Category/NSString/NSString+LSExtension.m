

//
//  NSString+LSExtension.m
//  driver
//
//  Created by 刘松 on 16/8/30.
//  Copyright © 2016年 driver. All rights reserved.
//

#import "NSString+LSExtension.h"
#import <CommonCrypto/CommonDigest.h>
#include <sys/sysctl.h>
#import <AdSupport/AdSupport.h>

#define LSEmojiCodeToSymbol(c)                                                 \
  ((((0x808080F0 | (c & 0x3F000) >> 4) | (c & 0xFC0) << 10) |                  \
    (c & 0x1C0000) << 18) |                                                    \
   (c & 0x3F) << 24)
#define HANZI_START 19968
#define HANZI_COUNT 20902
static char firstLetterArray[HANZI_COUNT] =
    "ydkqsxnwzssxjbymgcczqpssqbycdscdqldylybssjgyqzjjfgcclzznwdwzjljpfyynnjjtmy"
    "nzwzhflzppqhgccyynmjqyxxgd"
    "nnsnsjnjnsnnmlnrxyfsngnnnnqzggllyjlnyzssecykyyhqwjssggyxyqyjtwktjhychmnxjt"
    "lhjyqbyxdldwrrjnwysrldzjpc"
    "bzjjbrcfslnczstzfxxchtrqggddlyccssymmrjcyqzpwwjjyfcrwfdfzqpyddwyxkyjawjffx"
    "jbcftzyhhycyswccyxsclcxxwz"
    "cxnbgnnxbxlzsqsbsjpysazdhmdzbqbscwdzzyytzhbtsyyfzgntnxjywqnknphhlxgybfmjnb"
    "jhhgqtjcysxstkzglyckglysmz"
    "xyalmeldccxgzyrjxjzlnjzcqkcnnjwhjczccqljststbnhbtyxceqxkkwjyflzqlyhjxspsfx"
    "lmpbysxxxytccnylllsjxfhjxp"
    "jbtffyabyxbcczbzyclwlczggbtssmdtjcxpthyqtgjjxcjfzkjzjqnlzwlslhdzbwjncjzyzs"
    "qnycqynzcjjwybrtwpyftwexcs"
    "kdzctbyhyzqyyjxzcfbzzmjyxxsdczottbzljwfckscsxfyrlrygmbdthjxsqjccsbxyytswfb"
    "jdztnbcnzlcyzzpsacyzzsqqcs"
    "hzqydxlbpjllmqxqydzxsqjtzpxlcglqdcwzfhctdjjsfxjejjtlbgxsxjmyjjqpfzasyjnsyd"
    "jxkjcdjsznbartcclnjqmwnqnc"
    "lllkbdbzzsyhqcltwlccrshllzntylnewyzyxczxxgdkdmtcedejtsyyssdqdfmxdbjlkrwnql"
    "ybglxnlgtgxbqjdznyjsjyjcjm"
    "rnymgrcjczgjmzmgxmmryxkjnymsgmzzymknfxmbdtgfbhcjhkylpfmdxlxjjsmsqgzsjlqdld"
    "gjycalcmzcsdjllnxdjffffjcn"
    "fnnffpfkhkgdpqxktacjdhhzdddrrcfqyjkqccwjdxhwjlyllzgcfcqjsmlzpbjjblsbcjggdc"
    "kkdezsqcckjgcgkdjtjllzycxk"
    "lqccgjcltfpcqczgwbjdqyzjjbyjhsjddwgfsjgzkcjctllfspkjgqjhzzljplgjgjjthjjyjz"
    "ccmlzlyqbgjwmljkxzdznjqsyz"
    "mljlljkywxmkjlhskjhbmclyymkxjqlbmllkmdxxkwyxwslmlpsjqqjqxyqfjtjdxmxxllcrqb"
    "syjbgwynnggbcnxpjtgpapfgdj"
    "qbhbncfjyzjkjkhxqfgqckfhygkhdkllsdjqxpqyaybnqsxqnszswhbsxwhxwbzzxdmndjbsbk"
    "bbzklylxgwxjjwaqzmywsjqlsj"
    "xxjqwjeqxnchetlzalyyyszzpnkyzcptlshtzcfycyxyljsdcjqagyslcllyyysslqqqnldxzs"
    "ccscadycjysfsgbfrsszqsbxjp"
    "sjysdrckgjlgtkzjzbdktcsyqpyhstcldjnhmymcgxyzhjdctmhltxzhylamoxyjcltyfbqqjp"
    "fbdfehthsqhzywwcncxcdwhowg"
    "yjlegmdqcwgfjhcsntmydolbygnqwesqpwnmlrydzszzlyqpzgcwxhnxpyxshmdqjgztdppbfb"
    "hzhhjyfdzwkgkzbldnzsxhqeeg"
    "zxylzmmzyjzgszxkhkhtxexxgylyapsthxdwhzydpxagkydxbhnhnkdnjnmyhylpmgecslnzhk"
    "xxlbzzlbmlsfbhhgsgyyggbhsc"
    "yajtxglxtzmcwzydqdqmngdnllszhngjzwfyhqswscelqajynytlsxthaznkzzsdhlaxxtwwcj"
    "hqqtddwzbcchyqzflxpslzqgpz"
    "sznglydqtbdlxntctajdkywnsyzljhhdzckryyzywmhychhhxhjkzwsxhdnxlyscqydpslyzwm"
    "ypnkxyjlkchtyhaxqsyshxasmc"
    "hkdscrsgjpwqsgzjlwwschsjhsqnhnsngndantbaalczmsstdqjcjktscjnxplggxhhgoxzcxp"
    "dmmhldgtybynjmxhmrzplxjzck"
    "zxshflqxxcdhxwzpckczcdytcjyxqhlxdhypjqxnlsyydzozjnhhqezysjyayxkypdgxddnspp"
    "yzndhthrhxydpcjjhtcnnctlhb"
    "ynyhmhzllnnxmylllmdcppxhmxdkycyrdltxjchhznxclcclylnzsxnjzzlnnnnwhyqsnjhxyn"
    "ttdkyjpychhyegkcwtwlgjrlgg"
    "tgtygyhpyhylqyqgcwyqkpyyettttlhyylltyttsylnyzwgywgpydqqzzdqnnkcqnmjjzzbxtq"
    "fjkdffbtkhzkbxdjjkdjjtlbwf"
    "zpptkqtztgpdwntpjyfalqmkgxbcclzfhzcllllanpnxtjklcclgyhdzfgyddgcyyfgydxksse"
    "ndhykdndknnaxxhbpbyyhxccga"
    "pfqyjjdmlxcsjzllpcnbsxgjyndybwjspcwjlzkzddtacsbkzdyzypjzqsjnkktknjdjgyepgt"
    "lnyqnacdntcyhblgdzhbbydmjr"
    "egkzyheyybjmcdtafzjzhgcjnlghldwxjjkytcyksssmtwcttqzlpbszdtwcxgzagyktywxlnl"
    "cpbclloqmmzsslcmbjcsdzkydc"
    "zjgqjdsmcytzqqlnzqzxssbpkdfqmddzzsddtdmfhtdycnaqjqkypbdjyyxtljhdrqxlmhkydh"
    "rnlklytwhllrllrcxylbnsrnzz"
    "symqzzhhkyhxksmzsyzgcxfbnbsqlfzxxnnxkxwymsddyqnggqmmyhcdzttfgyyhgsbttybykj"
    "dnkyjbelhdypjqnfxfdnkzhqks"
    "byjtzbxhfdsbdaswpawajldyjsfhblcnndnqjtjnchxfjsrfwhzfmdrfjyxwzpdjkzyjympcyz"
    "nynxfbytfyfwygdbnzzzdnytxz"
    "emmqbsqehxfznbmflzzsrsyqjgsxwzjsprytjsjgskjjgljjynzjjxhgjkymlpyyycxycgqzsw"
    "hwlyrjlpxslcxmnsmwklcdnkny"
    "npsjszhdzeptxmwywxyysywlxjqcqxzdclaeelmcpjpclwbxsqhfwrtfnjtnqjhjqdxhwlbycc"
    "fjlylkyynldxnhycstyywncjtx"
    "ywtrmdrqnwqcmfjdxzmhmayxnwmyzqtxtlmrspwwjhanbxtgzypxyyrrclmpamgkqjszycymyj"
    "snxtplnbappypylxmyzkynldgy"
    "jzcchnlmzhhanqnbgwqtzmxxmllhgdzxnhxhrxycjmffxywcfsbssqlhnndycannmtcjcypnxn"
    "ytycnnymnmsxndlylysljnlxys"
    "sqmllyzlzjjjkyzzcsfbzxxmstbjgnxnchlsnmcjscyznfzlxbrnnnylmnrtgzqysatswryhyj"
    "zmgdhzgzdwybsscskxsyhytsxg"
    "cqgxzzbhyxjscrhmkkbsczjyjymkqhzjfnbhmqhysnjnzybknqmcjgqhwlsnzswxkhljhyybqc"
    "bfcdsxdldspfzfskjjzwzxsddx"
    "jseeegjscssygclxxnwwyllymwwwgydkzjggggggsycknjwnjpcxbjjtqtjwdsspjxcxnzxnme"
    "lptfsxtllxcljxjjljsxctnswx"
    "lennlyqrwhsycsqnybyaywjejqfwqcqqcjqgxaldbzzyjgkgxbltqyfxjltpydkyqhpmatlcnd"
    "nkxmtxynhklefxdllegqtymsaw"
    "hzmljtkynxlyjzljeeyybqqffnlyxhdsctgjhxywlkllxqkcctnhjlqmkkzgcyygllljdcgydh"
    "zwypysjbzjdzgyzzhywyfqdtyz"
    "szyezklymgjjhtsmqwyzljyywzcsrkqyqltdxwcdrjalwsqzwbdcqyncjnnszjlncdcdtlzzza"
    "cqqzzddxyblxcbqjylzllljddz"
    "jgyqyjzyxnyyyexjxksdaznyrdlzyyynjlslldyxjcykywnqcclddnyyynycgczhjxcclgzqjg"
    "nwnncqqjysbzzxyjxjnxjfzbsb"
    "dsfnsfpzxhdwztdmpptflzzbzdmyypqjrsdzsqzsqxbdgcpzswdwcsqzgmdhzxmwwfybpngphd"
    "mjthzsmmbgzmbzjcfzhfcbbnmq"
    "dfmbcmcjxlgpnjbbxgyhyyjgptzgzmqbqdcgybjxlwnkydpdymgcftpfxyztzxdzxtgkptybbc"
    "lbjaskytssqyymscxfjhhlslls"
    "jpqjjqaklyldlycctsxmcwfgngbqxllllnyxtyltyxytdpjhnhgnkbyqnfjyyzbyyessessgdy"
    "hfhwtcqbsdzjtfdmxhcnjzymqw"
    "srxjdzjqbdqbbsdjgnfbknbxdkqhmkwjjjgdllthzhhyyyyhhsxztyyyccbdbpypzyccztjpzy"
    "wcbdlfwzcwjdxxhyhlhwczxjtc"
    "nlcdpxnqczczlyxjjcjbhfxwpywxzpcdzzbdccjwjhmlxbqxxbylrddgjrrctttgqdczwmxfyt"
    "mmzcwjwxyywzzkybzcccttqnhx"
    "nwxxkhkfhtswoccjybcmpzzykbnnzpbthhjdlszddytyfjpxyngfxbyqxzbhxcpxxtnzdnnycn"
    "xsxlhkmzxlthdhkghxxsshqyhh"
    "cjyxglhzxcxnhekdtgqxqypkdhentykcnymyyjmkqyyyjxzlthhqtbyqhxbmyhsqckwwyllhcy"
    "ylnneqxqwmcfbdccmljggxdqkt"
    "lxkknqcdgcjwyjjlyhhqyttnwchhxcxwherzjydjccdbqcdgdnyxzdhcqrxcbhztqcbxwgqwyy"
    "bxhmbymykdyecmqkyaqyngyzsl"
    "fnkkqgyssqyshngjctxkzycssbkyxhyylstycxqthysmnscpmmgcccccmnztasmgqzjhklosjy"
    "lswtmqzyqkdzljqqyplzycztcq"
    "qpbbcjzclpkhqcyyxxdtdddsjcxffllchqxmjlwcjcxtspycxndtjshjwhdqqqckxyamylsjhm"
    "lalygxcyydmamdqmlmcznnyybz"
    "xkyflmcncmlhxrcjjhsylnmtjggzgywjxsrxcwjgjqhqzdqjdcjjskjkgdzcgjjyjylxzxxcdq"
    "hhheslmhlfsbdjsyyshfyssczq"
    "lpbdrfnztzdkykhsccgkwtqzckmsynbcrxqbjyfaxpzzedzcjykbcjwhyjbqzzywnyszptdkzp"
    "fpbaztklqnhbbzptpptyzzybhn"
    "ydcpzmmcycqmcjfzzdcmnlfpbplngqjtbttajzpzbbdnjkljqylnbzqhksjznggqstzkcxchpz"
    "snbcgzkddzqanzgjkdrtlzldwj"
    "njzlywtxndjzjhxnatncbgtzcsskmljpjytsnwxcfjwjjtkhtzplbhsnjssyjbhbjyzlstlsbj"
    "hdnwqpslmmfbjdwajyzccjtbnn"
    "nzwxxcdslqgdsdpdzgjtqqpsqlyyjzlgyhsdlctcbjtktyczjtqkbsjlgnnzdncsgpynjzjjyy"
    "knhrpwszxmtncszzyshbyhyzax"
    "ywkcjtllckjjtjhgcssxyqyczbynnlwqcglzgjgqyqcczssbcrbcskydznxjsqgxssjmecnstj"
    "tpbdlthzwxqwqczexnqczgwesg"
    "ssbybstscslccgbfsdqnzlccglllzghzcthcnmjgyzazcmsksstzmmzckbjygqljyjppldxrkz"
    "yxccsnhshhdznlzhzjjcddcbcj"
    "xlbfqbczztpqdnnxljcthqzjgylklszzpcjdscqjhjqkdxgpbajynnsmjtzdxlcjyryynhjbng"
    "zjkmjxltbsllrzpylssznxjhll"
    "hyllqqzqlsymrcncxsljmlzltzldwdjjllnzggqxppskyggggbfzbdkmwggcxmcgdxjmcjsdyc"
    "abxjdlnbcddygskydqdxdjjyxh"
    "saqazdzfslqxxjnqzylblxxwxqqzbjzlfbblylwdsljhxjyzjwtdjcyfqzqzzdzsxzzqlzcdzf"
    "xhwspynpqzmlpplffxjjnzzyls"
    "jnyqzfpfzgsywjjjhrdjzzxtxxglghtdxcskyswmmtcwybazbjkshfhgcxmhfqhyxxyzftsjyz"
    "bxyxpzlchmzmbxhzzssyfdmncw"
    "dabazlxktcshhxkxjjzjsthygxsxyyhhhjwxkzxssbzzwhhhcwtzzzpjxsyxqqjgzyzawllcwx"
    "znxgyxyhfmkhydwsqmnjnaycys"
    "pmjkgwcqhylajgmzxhmmcnzhbhxclxdjpltxyjkdyylttxfqzhyxxsjbjnayrsmxyplckdnyhl"
    "xrlnllstycyyqygzhhsccsmcct"
    "zcxhyqfpyyrpbflfqnntszlljmhwtcjqyzwtlnmlmdwmbzzsnzrbpdddlqjjbxtcsnzqqygwcs"
    "xfwzlxccrszdzmcyggdyqsgtnn"
    "nlsmymmsyhfbjdgyxccpshxczcsbsjyygjmpbwaffyfnxhydxzylremzgzzyndsznlljcsqfnx"
    "xkptxzgxjjgbmyyssnbtylbnlh"
    "bfzdcyfbmgqrrmzszxysjtznnydzzcdgnjafjbdknzblczszpsgcycjszlmnrznbzzldlnllys"
    "xsqzqlcxzlsgkbrxbrbzcycxzj"
    "zeeyfgklzlnyhgzcgzlfjhgtgwkraajyzkzqtsshjjxdzyznynnzyrzdqqhgjzxsszbtkjbbfr"
    "tjxllfqwjgclqtymblpzdxtzag"
    "bdhzzrbgjhwnjtjxlkscfsmwlldcysjtxkzscfwjlbnntzlljzllqblcqmqqcgcdfpbphzczjl"
    "pyyghdtgwdxfczqyyyqysrclqz"
    "fklzzzgffcqnwglhjycjjczlqzzyjbjzzbpdcsnnjgxdqnknlznnnnpsntsdyfwwdjzjysxyyc"
    "zcyhzwbbyhxrylybhkjksfxtjj"
    "mmchhlltnyymsxxyzpdjjycsycwmdjjkqyrhllngpngtlyycljnnnxjyzfnmlrgjjtyzbsyzms"
    "jyjhgfzqmsyxrszcytlrtqzsst"
    "kxgqkgsptgxdnjsgcqcqhmxggztqydjjznlbznxqlhyqgggthqscbyhjhhkyygkggcmjdzllcc"
    "lxqsftgjslllmlcskctbljszsz"
    "mmnytpzsxqhjcnnqnyexzqzcpshkzzyzxxdfgmwqrllqxrfztlystctmjcsjjthjnxtnrztzfq"
    "rhcgllgcnnnnjdnlnnytsjtlny"
    "xsszxcgjzyqpylfhdjsbbdczgjjjqzjqdybssllcmyttmqnbhjqmnygjyeqyqmzgcjkpdcnmyz"
    "gqllslnclmholzgdylfzslncnz"
    "lylzcjeshnyllnxnjxlyjyyyxnbcljsswcqqnnyllzldjnllzllbnylnqchxyyqoxccqkyjxxx"
    "yklksxeyqhcqkkkkcsnyxxyqxy"
    "gwtjohthxpxxhsnlcykychzzcbwqbbwjqcscszsslcylgddsjzmmymcytsdsxxscjpqqsqylyf"
    "zychdjynywcbtjsydchcyddjlb"
    "djjsodzyqyskkyxdhhgqjyohdyxwgmmmazdybbbppbcmnnpnjzsmtxerxjmhqdntpjdcbsnmss"
    "ythjtslmltrcplzszmlqdsdmjm"
    "qpnqdxcfrnnfsdqqyxhyaykqyddlqyyysszbydslntfgtzqbzmchdhczcwfdxtmqqsphqwwxsr"
    "gjcwnntzcqmgwqjrjhtqjbbgwz"
    "fxjhnqfxxqywyyhyscdydhhqmrmtmwctbszppzzglmzfollcfwhmmsjzttdhlmyffytzzgzysk"
    "jjxqyjzqbhmbzclyghgfmshpcf"
    "zsnclpbqsnjyzslxxfpmtyjygbxlldlxpzjyzjyhhzcywhjylsjexfszzywxkzjlnadymlymqj"
    "pwxxhxsktqjezrpxxzghmhwqpw"
    "qlyjjqjjzszcnhjlchhnxjlqwzjhbmzyxbdhhypylhlhlgfwlcfyytlhjjcwmscpxstkpnhjxs"
    "ntyxxtestjctlsslstdlllwwyh"
    "dnrjzsfgxssyczykwhtdhwjglhtzdqdjzxxqgghltzphcsqfclnjtclzpfstpdynylgmjllycq"
    "hynspchylhqyqtmzymbywrfqyk"
    "jsyslzdnjmpxyyssrhzjnyqtqdfzbwwdwwrxcwggyhxmkmyyyhmxmzhnksepmlqqmtcwctmxmx"
    "jpjjhfxyyzsjzhtybmstsyjznq"
    "jnytlhynbyqclcycnzwsmylknjxlggnnpjgtysylymzskttwlgsmzsylmpwlcwxwqcssyzsyxy"
    "rhssntsrwpccpwcmhdhhxzdzyf"
    "jhgzttsbjhgyglzysmyclllxbtyxhbbzjkssdmalhhycfygmqypjyjqxjllljgclzgqlycjcct"
    "otyxmtmshllwlqfxymzmklpszz"
    "cxhkjyclctyjcyhxsgyxnnxlzwpyjpxhjwpjpwxqqxlxsdhmrslzzydwdtcxknstzshbsccstp"
    "lwsscjchjlcgchssphylhfhhxj"
    "sxallnylmzdhzxylsxlmzykcldyahlcmddyspjtqjzlngjfsjshctsdszlblmssmnyymjqbjhr"
    "zwtyydchjljapzwbgqxbkfnbjd"
    "llllyylsjydwhxpsbcmljpscgbhxlqhyrljxyswxhhzlldfhlnnymjljyflyjycdrjlfsyzfsl"
    "lcqyqfgqyhnszlylmdtdjcnhbz"
    "llnwlqxygyyhbmgdhxxnhlzzjzxczzzcyqzfngwpylcpkpykpmclgkdgxzgxwqbdxzzkzfbddl"
    "zxjtpjpttbythzzdwslcpnhslt"
    "jxxqlhyxxxywzyswttzkhlxzxzpyhgzhknfsyhntjrnxfjcpjztwhplshfcrhnslxxjxxyhzqd"
    "xqwnnhyhmjdbflkhcxcwhjfyjc"
    "fpqcxqxzyyyjygrpynscsnnnnchkzdyhflxxhjjbyzwttxnncyjjymswyxqrmhxzwfqsylzngg"
    "bhyxnnbwttcsybhxxwxyhhxyxn"
    "knyxmlywrnnqlxbbcljsylfsytjzyhyzawlhorjmnsczjxxxyxchcyqryxqzddsjfslyltsffy"
    "xlmtyjmnnyyyxltzcsxqclhzxl"
    "wyxzhnnlrxkxjcdyhlbrlmbrdlaxksnlljlyxxlynrylcjtgncmtlzllcyzlpzpzyawnjjfybd"
    "yyzsepckzzqdqpbpsjpdyttbdb"
    "bbyndycncpjmtmlrmfmmrwyfbsjgygsmdqqqztxmkqwgxllpjgzbqrdjjjfpkjkcxbljmswldt"
    "sjxldlppbxcwkcqqbfqbccajzg"
    "mykbhyhhzykndqzybpjnspxthlfpnsygyjdbgxnhhjhzjhstrstldxskzysybmxjlxyslbzysl"
    "zxjhfybqnbylljqkygzmcyzzym"
    "ccslnlhzhwfwyxzmwyxtynxjhbyymcysbmhysmydyshnyzchmjjmzcaahcbjbbhblytylsxsnx"
    "gjdhkxxtxxnbhnmlngsltxmrhn"
    "lxqqxmzllyswqgdlbjhdcgjyqyymhwfmjybbbyjyjwjmdpwhxqldyapdfxxbcgjspckrssyzjm"
    "slbzzjfljjjlgxzgyxyxlszqkx"
    "bexyxhgcxbpndyhwectwwcjmbtxchxyqqllxflyxlljlssnwdbzcmyjclwswdczpchqekcqbwl"
    "cgydblqppqzqfnqdjhymmcxtxd"
    "rmzwrhxcjzylqxdyynhyyhrslnrsywwjjymtltllgtqcjzyabtckzcjyccqlysqxalmzynywlw"
    "dnzxqdllqshgpjfjljnjabcqzd"
    "jgthhsstnyjfbswzlxjxrhgldlzrlzqzgsllllzlymxxgdzhgbdphzpbrlwnjqbpfdwonnnhly"
    "pcnjccndmbcpbzzncyqxldomzb"
    "lzwpdwyygdstthcsqsccrsssyslfybnntyjszdfndpdhtqzmbqlxlcmyffgtjjqwftmnpjwdnl"
    "bzcmmcngbdzlqlpnfhyymjylsd"
    "chdcjwjcctljcldtljjcbddpndsszycndbjlggjzxsxnlycybjjxxcbylzcfzppgkcxqdzfztj"
    "jfjdjxzbnzyjqctyjwhdyczhym"
    "djxttmpxsplzcdwslshxypzgtfmlcjtacbbmgdewycyzxdszjyhflystygwhkjyylsjcxgywjc"
    "bllcsnddbtzbsclyzczzssqdll"
    "mjyyhfllqllxfdyhabxggnywyypllsdldllbjcyxjznlhljdxyyqytdlllbngpfdfbbqbzzmdp"
    "jhgclgmjjpgaehhbwcqxajhhhz"
    "chxyphjaxhlphjpgpzjqcqzgjjzzgzdmqyybzzphyhybwhazyjhykfgdpfqsdlzmljxjpgalxz"
    "daglmdgxmmzqwtxdxxpfdmmssy"
    "mpfmdmmkxksyzyshdzkjsysmmzzzmdydyzzczxbmlstmdyemxckjmztyymzmzzmsshhdccjewx"
    "xkljsthwlsqlyjzllsjssdppmh"
    "nlgjczyhmxxhgncjmdhxtkgrmxfwmckmwkdcksxqmmmszzydkmsclcmpcjmhrpxqpzdsslcxky"
    "xtwlkjyahzjgzjwcjnxyhmmbml"
    "gjxmhlmlgmxctkzmjlyscjsyszhsyjzjcdajzhbsdqjzgwtkqxfkdmsdjlfmnhkzqkjfeypzys"
    "zcdpynffmzqykttdzzefmzlbnp"
    "plplpbpszalltnlkckqzkgenjlwalkxydpxnhsxqnwqnkxqclhyxxmlnccwlymqyckynnlcjns"
    "zkpyzkcqzqljbdmdjhlasqlbyd"
    "wqlwdgbqcryddztjybkbwszdxdtnpjdtcnqnfxqqmgnseclstbhpwslctxxlpwydzklnqgzcqa"
    "pllkqcylbqmqczqcnjslqzdjxl"
    "ddhpzqdljjxzqdjyzhhzlkcjqdwjppypqakjyrmpzbnmcxkllzllfqpylllmbsglzysslrsysq"
    "tmxyxzqzbscnysyztffmzzsmzq"
    "hzssccmlyxwtpzgxzjgzgsjzgkddhtqggzllbjdzlsbzhyxyzhzfywxytymsdnzzyjgtcmtnxq"
    "yxjscxhslnndlrytzlryylxqht"
    "xsrtzcgyxbnqqzfhykmzjbzymkbpnlyzpblmcnqyzzzsjztjctzhhyzzjrdyzhnfxklfzslkgj"
    "tctssyllgzrzbbjzzklpkbczys"
    "nnyxbjfbnjzzxcdwlzyjxzzdjjgggrsnjkmsmzjlsjywqsnyhqjsxpjztnlsnshrnynjtwchgl"
    "bnrjlzxwjqxqkysjycztlqzybb"
    "ybyzjqdwgyzcytjcjxckcwdkkzxsnkdnywwyyjqyytlytdjlxwkcjnklccpzcqqdzzqlcsfqch"
    "qqgssmjzzllbjjzysjhtsjdysj"
    "qjpdszcdchjkjzzlpycgmzndjxbsjzzsyzyhgxcpbjydssxdzncglqmbtsfcbfdzdlznfgfjgf"
    "smpnjqlnblgqcyyxbqgdjjqsrf"
    "kztjdhczklbsdzcfytplljgjhtxzcsszzxstjygkgckgynqxjplzbbbgcgyjzgczqszlbjlsjf"
    "zgkqqjcgycjbzqtldxrjnbsxxp"
    "zshszycfwdsjjhxmfczpfzhqhqmqnknlyhtycgfrzgnqxcgpdlbzcsczqlljblhbdcypscppdy"
    "mzzxgyhckcpzjgslzlnscnsldl"
    "xbmsdlddfjmkdqdhslzxlsznpqpgjdlybdskgqlbzlnlkyyhzttmcjnqtzzfszqktlljtyylln"
    "llqyzqlbdzlslyyzxmdfszsnxl"
    "xznczqnbbwskrfbcylctnblgjpmczzlstlxshtzcyzlzbnfmqnlxflcjlyljqcbclzjgnsstbr"
    "mhxzhjzclxfnbgxgtqncztmsfz"
    "kjmssncljkbhszjntnlzdntlmmjxgzjyjczxyhyhwrwwqnztnfjscpyshzjfyrdjsfscjzbjfz"
    "qzchzlxfxsbzqlzsgyftzdcszx"
    "zjbjpszkjrhxjzcgbjkhcggtxkjqglxbxfgtrtylxqxhdtsjxhjzjjcmzlcqsbtxwqgxtxxhxf"
    "tsdkfjhzyjfjxnzldlllcqsqqz"
    "qwqxswqtwgwbzcgcllqzbclmqjtzgzyzxljfrmyzflxnsnxxjkxrmjdzdmmyxbsqbhgzmwfwyg"
    "mjlzbyytgzyccdjyzxsngnyjyz"
    "nbgpzjcqsyxsxrtfyzgrhztxszzthcbfclsyxzlzqmzlmplmxzjssfsbysmzqhxxnxrxhqzzzs"
    "slyflczjrcrxhhzxqndshxsjjh"
    "qcjjbcynsysxjbqjpxzqplmlxzkyxlxcnlcycxxzzlxdlllmjyhzxhyjwkjrwyhcpsgnrzlfzw"
    "fzznsxgxflzsxzzzbfcsyjdbrj"
    "krdhhjxjljjtgxjxxstjtjxlyxqfcsgswmsbctlqzzwlzzkxjmltmjyhsddbxgzhdlbmyjfrzf"
    "cgclyjbpmlysmsxlszjqqhjzfx"
    "gfqfqbphngyyqxgztnqwyltlgwgwwhnlfmfgzjmgmgbgtjflyzzgzyzaflsspmlbflcwbjztlj"
    "jmzlpjjlymqtmyyyfbgygqzgly"
    "zdxqyxrqqqhsxyyqxygjtyxfsfsllgnqcygycwfhcccfxpylypllzqxxxxxqqhhsshjzcftscz"
    "jxspzwhhhhhapylqnlpqafyhxd"
    "ylnkmzqgggddesrenzltzgchyppcsqjjhclljtolnjpzljlhymhezdydsqycddhgznndzclzyw"
    "llznteydgnlhslpjjbdgwxpcnn"
    "tycklkclwkllcasstknzdnnjttlyyzssysszzryljqkcgdhhyrxrzydgrgcwcgzqffbppjfzyn"
    "akrgywyjpqxxfkjtszzxswzddf"
    "bbqtbgtzkznpzfpzxzpjszbmqhkyyxyldkljnypkyghgdzjxxeaxpnznctzcmxcxmmjxnkszqn"
    "mnlwbwwqjjyhclstmcsxnjcxxt"
    "pcnfdtnnpglllzcjlspblpgjcdtnjjlyarscffjfqwdpgzdwmrzzcgodaxnssnyzrestyjwjyj"
    "dbcfxnmwttbqlwstszgybljpxg"
    "lbnclgpcbjftmxzljylzxcltpnclcgxtfzjshcrxsfysgdkntlbyjcyjllstgqcbxnhzxbxkly"
    "lhzlqzlnzcqwgzlgzjncjgcmnz"
    "zgjdzxtzjxycyycxxjyyxjjxsssjstsstdppghtcsxwzdcsynptfbchfbblzjclzzdbxgcjlhp"
    "xnfzflsyltnwbmnjhszbmdnbcy"
    "sccldnycndqlyjjhmqllcsgljjsyfpyyccyltjantjjpwycmmgqyysxdxqmzhszxbftwwzqswq"
    "rfkjlzjqqyfbrxjhhfwjgzyqac"
    "myfrhcyybynwlpexcczsyyrlttdmqlrkmpbgmyyjprkznbbsqyxbhyzdjdnghpmfsgbwfzmfqm"
    "mbzmzdcgjlnnnxyqgmlrygqccy"
    "xzlwdkcjcggmcjjfyzzjhycfrrcmtznzxhkqgdjxccjeascrjthpljlrzdjrbcqhjdnrhylyqj"
    "symhzydwcdfryhbbydtssccwbx"
    "glpzmlzjdqsscfjmmxjcxjytycghycjwynsxlfemwjnmkllswtxhyyyncmmcyjdqdjzglljwjn"
    "khpzggflccsczmcbltbhbqjxqd"
    "jpdjztghglfjawbzyzjltstdhjhctcbchflqmpwdshyytqwcnntjtlnnmnndyyyxsqkxwyyflx"
    "xnzwcxypmaelyhgjwzzjbrxxaq"
    "jfllpfhhhytzzxsgqjmhspgdzqwbwpjhzjdyjcqwxkthxsqlzyymysdzgnqckknjlwpnsyscsy"
    "zlnmhqsyljxbcxtlhzqzpcycyk"
    "pppnsxfyzjjrcemhszmnxlxglrwgcstlrsxbygbzgnxcnlnjlclynymdxwtzpalcxpqjcjwtcy"
    "yjlblxbzlqmyljbghdslssdmxm"
    "bdczsxyhamlczcpjmcnhjyjnsykchskqmczqdllkablwjqsfmocdxjrrlyqchjmybyqlrhetfj"
    "zfrfksryxfjdwtsxxywsqjysly"
    "xwjhsdlxyyxhbhawhwjcxlmyljcsqlkydttxbzslfdxgxsjkhsxxybssxdpwncmrptqzczenyg"
    "cxqfjxkjbdmljzmqqxnoxslyxx"
    "lylljdzptymhbfsttqqwlhsgynlzzalzxclhtwrrqhlstmypyxjjxmnsjnnbryxyjllyqyltwy"
    "lqyfmlkljdnlltfzwkzhljmlhl"
    "jnljnnlqxylmbhhlnlzxqchxcfxxlhyhjjgbyzzkbxscqdjqdsndzsygzhhmgsxcsymxfepcqw"
    "wrbpyyjqryqcyjhqqzyhmwffhg"
    "zfrjfcdbxntqyzpcyhhjlfrzgpbxzdbbgrqstlgdgylcqmgchhmfywlzyxkjlypjhsywmqqggz"
    "mnzjnsqxlqsyjtcbehsxfszfxz"
    "wfllbcyyjdytdthwzsfjmqqyjlmqsxlldttkghybfpwdyysqqrnqwlgwdebzwcyygcnlkjxtmx"
    "myjsxhybrwfymwfrxyymxysctz"
    "ztfykmldhqdlgyjnlcryjtlpsxxxywlsbrrjwxhqybhtydnhhxmmywytycnnmnssccdalwztcp"
    "qpyjllqzyjswjwzzmmglmxclmx"
    "nzmxmzsqtzppjqblpgxjzhfljjhycjsrxwcxsncdlxsyjdcqzxslqyclzxlzzxmxqrjmhrhzjb"
    "hmfljlmlclqnldxzlllfyprgjy"
    "nxcqqdcmqjzzxhnpnxzmemmsxykynlxsxtljxyhwdcwdzhqyybgybcyscfgfsjnzdrzzxqxrzr"
    "qjjymcanhrjtldbpyzbstjhxxz"
    "ypbdwfgzzrpymnnkxcqbyxnbnfyckrjjcmjegrzgyclnnzdnkknsjkcljspgyyclqqjybzssql"
    "llkjftbgtylcccdblsppfylgyd"
    "tzjqjzgkntsfcxbdkdxxhybbfytyhbclnnytgdhryrnjsbtcsnyjqhklllzslydxxwbcjqsbxn"
    "pjzjzjdzfbxxbrmladhcsnclbj"
    "dstblprznswsbxbcllxxlzdnzsjpynyxxyftnnfbhjjjgbygjpmmmmsszljmtlyzjxswxtyled"
    "qpjmpgqzjgdjlqjwjqllsdgjgy"
    "gmscljjxdtygjqjjjcjzcjgdzdshqgzjggcjhqxsnjlzzbxhsgzxcxyljxyxyydfqqjhjfxdhc"
    "txjyrxysqtjxyefyyssyxjxncy"
    "zxfxcsxszxyyschshxzzzgzzzgfjdldylnpzgsjaztyqzpbxcbdztzczyxxyhhscjshcggqhjh"
    "gxhsctmzmehyxgebtclzkkwytj"
    "zrslekestdbcyhqqsayxcjxwwgsphjszsdncsjkqcxswxfctynydpccczjqtcwjqjzzzqzljzh"
    "lsbhpydxpsxshhezdxfptjqyzc"
    "xhyaxncfzyyhxgnqmywntzsjbnhhgymxmxqcnssbcqsjyxxtyyhybcqlmmszmjzzllcogxzaaj"
    "zyhjmchhcxzsxsdznleyjjzjbh"
    "zwjzsqtzpsxzzdsqjjjlnyazphhyysrnqzthzhnyjyjhdzxzlswclybzyecwcycrylchzhzydz"
    "ydyjdfrjjhtrsqtxyxjrjhojyn"
    "xelxsfsfjzghpzsxzszdzcqzbyyklsgsjhczshdgqgxyzgxchxzjwyqwgyhksseqzzndzfkwys"
    "sdclzstsymcdhjxxyweyxczayd"
    "mpxmdsxybsqmjmzjmtjqlpjyqzcgqhyjhhhqxhlhdldjqcfdwbsxfzzyyschtytyjbhecxhjkg"
    "qfxbhyzjfxhwhbdzfyzbchpnpg"
    "dydmsxhkhhmamlnbyjtmpxejmcthqbzyfcgtyhwphftgzzezsbzegpbmdskftycmhbllhgpzjx"
    "zjgzjyxzsbbqsczzlzscstpgxm"
    "jsfdcczjzdjxsybzlfcjsazfgszlwbczzzbyztzynswyjgxzbdsynxlgzbzfygczxbzhzftpbg"
    "zgejbstgkdmfhyzzjhzllzzgjq"
    "zlsfdjsscbzgpdlfzfzszyzyzsygcxsnxxchczxtzzljfzgqsqqxcjqccccdjcdszzyqjccgxz"
    "tdlgscxzsyjjqtcclqdqztqchq"
    "qyzynzzzpbkhdjfcjfztypqyqttynlmbdktjcpqzjdzfpjsbnjlgyjdxjdcqkzgqkxclbzjtcj"
    "dqbxdjjjstcxnxbxqmslyjcxnt"
    "jqwwcjjnjjlllhjcwqtbzqqczczpzzdzyddcyzdzccjgtjfzdprntctjdcxtqzdtjnplzbcllc"
    "tdsxkjzqdmzlbznbtjdcxfczdb"
    "czjjltqqpldckztbbzjcqdcjwynllzlzccdwllxwzlxrxntqjczxkjlsgdnqtddglnlajjtnny"
    "nkqlldzntdnycygjwyxdxfrsqs"
    "tcdenqmrrqzhhqhdldazfkapbggpzrebzzykyqspeqjjglkqzzzjlysyhyzwfqznlzzlzhwcgk"
    "ypqgnpgblplrrjyxcccgyhsfzf"
    "wbzywtgzxyljczwhncjzplfflgskhyjdeyxhlpllllcygxdrzelrhgklzzyhzlyqszzjzqljzf"
    "lnbhgwlczcfjwspyxzlzlxgccp"
    "zbllcxbbbbnbbcbbcrnnzccnrbbnnldcgqyyqxygmqzwnzytyjhyfwtehznjywlccntzyjjcde"
    "dpwdztstnjhtymbjnyjzlxtsst"
    "phndjxxbyxqtzqddtjtdyztgwscszqflshlnzbcjbhdlyzjyckwtydylbnydsdsycctyszyyeb"
    "gexhqddwnygyclxtdcystqnygz"
    "ascsszzdzlcclzrqxyywljsbymxshzdembbllyyllytdqyshymrqnkfkbfxnnsbychxbwjyhtq"
    "bpbsbwdzylkgzskyghqzjxhxjx"
    "gnljkzlyycdxlfwfghljgjybxblybxqpqgntzplncybxdjyqydymrbeyjyyhkxxstmxrczzjwx"
    "yhybmcflyzhqyzfwxdbxbcwzms"
    "lpdmyckfmzklzcyqycclhxfzlydqzpzygyjyzmdxtzfnnyttqtzhgsfcdmlccytzxjcytjmksl"
    "pzhysnwllytpzctzccktxdhxxt"
    "qcyfksmqccyyazhtjplylzlyjbjxtfnyljyynrxcylmmnxjsmybcsysslzylljjgyldzdlqhfz"
    "zblfndsqkczfyhhgqmjdsxyctt"
    "xnqnjpyybfcjtyyfbnxejdgyqbjrcnfyyqpghyjsyzngrhtknlnndzntsmgklbygbpyszbydjz"
    "sstjztsxzbhbscsbzczptqfzlq"
    "flypybbjgszmnxdjmtsyskkbjtxhjcegbsmjyjzcstmljyxrczqscxxqpyzhmkyxxxjcljyrmy"
    "ygadyskqlnadhrskqxzxztcggz"
    "dlmlwxybwsyctbhjhcfcwzsxwwtgzlxqshnyczjxemplsrcgltnzntlzjcyjgdtclglbllqpjm"
    "zpapxyzlaktkdwczzbncctdqqz"
    "qyjgmcdxltgcszlmlhbglkznnwzndxnhlnmkydlgxdtwcfrjerctzhydxykxhwfzcqshknmqqh"
    "zhhymjdjskhxzjzbzzxympajnm"
    "ctbxlsxlzynwrtsqgscbptbsgzwyhtlkssswhzzlyytnxjgmjrnsnnnnlskztxgxlsammlbwld"
    "qhylakqcqctmycfjbslxclzjcl"
    "xxknbnnzlhjphqplsxsckslnhpsfqcytxjjzljldtzjjzdlydjntptnndskjfsljhylzqqzlbt"
    "hydgdjfdbyadxdzhzjnthqbykn"
    "xjjqczmlljzkspldsclbblnnlelxjlbjycxjxgcnlcqplzlznjtsljgyzdzpltqcssfdmnycxg"
    "btjdcznbgbqyqjwgkfhtnbyqzq"
    "gbkpbbyzmtjdytblsqmbsxtbnpdxklemyycjynzdtldykzzxtdxhqshygmzsjycctayrzlpwlt"
    "lkxslzcggexclfxlkjrtlqjaqz"
    "ncmbqdkkcxglczjzxjhptdjjmzqykqsecqzdshhadmlzfmmzbgntjnnlhbyjbrbtmlbyjdzxlc"
    "jlpldlpcqdhlhzlycblcxccjad"
    "qlmzmmsshmybhbnkkbhrsxxjmxmdznnpklbbrhgghfchgmnklltsyyycqlcskymyehywxnxqyw"
    "bawykqldnntndkhqcgdqktgpkx"
    "hcpdhtwnmssyhbwcrwxhjmkmzngwtmlkfghkjyldyycxwhyyclqhkqhtdqkhffldxqwytyydes"
    "bpkyrzpjfyyzjceqdzzdlattpb"
    "fjllcxdlmjsdxegwgsjqxcfbssszpdyzcxznyxppzydlyjccpltxlnxyzyrscyyytylwwndsah"
    "jsygyhgywwaxtjzdaxysrltdps"
    "syxfnejdxyzhlxlllzhzsjnyqyqyxyjghzgjcyjchzlycdshhsgczyjscllnxzjjyyxnfsmwfp"
    "yllyllabmddhwzxjmcxztzpmlq"
    "chsfwzynctlndywlslxhymmylmbwwkyxyaddxylldjpybpwnxjmmmllhafdllaflbnhhbqqjqz"
    "jcqjjdjtffkmmmpythygdrjrdd"
    "wrqjxnbysrmzdbyytbjhpymyjtjxaahggdqtmystqxkbtzbkjlxrbyqqhxmjjbdjntgtbxpgbk"
    "tlgqxjjjcdhxqdwjlwrfmjgwqh"
    "cnrxswgbtgygbwhswdwrfhwytjjxxxjyzyslphyypyyxhydqpxshxyxgskqhywbdddpplcjlhq"
    "eewjgsyykdpplfjthkjltcyjhh"
    "jttpltzzcdlyhqkcjqysteeyhkyzyxxyysddjkllpymqyhqgxqhzrhbxpllnqydqhxsxxwgdqb"
    "shyllpjjjthyjkyphthyyktyez"
    "yenmdshlzrpqfbnfxzbsftlgxsjbswyysksflxlpplbbblnsfbfyzbsjssylpbbffffsscjdst"
    "jsxtryjcyffsyzyzbjtlctsbsd"
    "hrtjjbytcxyyeylycbnebjdsysyhgsjzbxbytfzwgenhhhthjhhxfwgcstbgxklstyymtmbyxj"
    "skzscdyjrcythxzfhmymcxlzns"
    "djtxtxrycfyjsbsdyerxhljxbbdeynjghxgckgscymblxjmsznskgxfbnbbthfjyafxwxfbxmy"
    "fhdttcxzzpxrsywzdlybbktyqw"
    "qjbzypzjznjpzjlztfysbttslmptzrtdxqsjehbnylndxljsqmlhtxtjecxalzzspktlzkqqyf"
    "syjywpcpqfhjhytqxzkrsgtksq"
    "czlptxcdyyzsslzslxlzmacpcqbzyxhbsxlzdltztjtylzjyytbzypltxjsjxhlbmytxcqrblz"
    "ssfjzztnjytxmyjhlhpblcyxqj"
    "qqkzzscpzkswalqsplczzjsxgwwwygyatjbbctdkhqhkgtgpbkqyslbxbbckbmllndzstbklgg"
    "qkqlzbkktfxrmdkbftpzfrtppm"
    "ferqnxgjpzsstlbztpszqzsjdhljqlzbpmsmmsxlqqnhknblrddnhxdkddjcyyljfqgzlgsygm"
    "jqjkhbpmxyxlytqwlwjcpbmjxc"
    "yzydrjbhtdjyeqshtmgsfyplwhlzffnynnhxqhpltbqpfbjwjdbygpnxtbfzjgnnntjshxeawt"
    "zylltyqbwjpgxghnnkndjtmszs"
    "qynzggnwqtfhclssgmnnnnynzqqxncjdqgzdlfnykljcjllzlmzznnnnsshthxjlzjbbhqjwwy"
    "crdhlyqqjbeyfsjhthnrnwjhwp"
    "slmssgzttygrqqwrnlalhmjtqjsmxqbjjzjqzyzkxbjqxbjxshzssfglxmxnxfghkzszggslcn"
    "narjxhnlllmzxelglxydjytlfb"
    "kbpnlyzfbbhptgjkwetzhkjjxzxxglljlstgshjjyqlqzfkcgnndjsszfdbctwwseqfhqjbsaq"
    "tgypjlbxbmmywxgslzhglsgnyf"
    "ljbyfdjfngsfmbyzhqffwjsyfyjjphzbyyzffwotjnlmftwlbzgyzqxcdjygzyyryzynyzwega"
    "zyhjjlzrthlrmgrjxzclnnnljj"
    "yhtbwjybxxbxjjtjteekhwslnnlbsfazpqqbdlqjjtyyqlyzkdksqjnejzldqcgjqnnjsncmrf"
    "qthtejmfctyhypymhydmjncfgy"
    "yxwshctxrljgjzhzcyyyjltkttntmjlzclzzayyoczlrlbszywjytsjyhbyshfjlykjxxtmzyy"
    "ltxxypslqyjzyzyypnhmymdyyl"
    "blhlsyygqllnjjymsoycbzgdlyxylcqyxtszegxhzglhwbljheyxtwqmakbpqcgyshhegqcmwy"
    "ywljyjhyyzlljjylhzyhmgsljl"
    "jxcjjyclycjbcpzjzjmmwlcjlnqljjjlxyjmlszljqlycmmgcfmmfpqqmfxlqmcffqmmmmhnzn"
    "fhhjgtthxkhslnchhyqzxtmmqd"
    "cydyxyqmyqylddcyaytazdcymdydlzfffmmycqcwzzmabtbyctdmndzggdftypcgqyttssffwb"
    "dttqssystwnjhjytsxxylbyyhh"
    "whxgzxwznnqzjzjjqjccchykxbzszcnjtllcqxynjnckycynccqnxyewyczdcjycchyjlbtzyy"
    "cqwlpgpyllgktltlgkgqbgychj"
    "xy";

@implementation NSString (LSExtension)



#pragma mark - 获取设备相关信息
+ (NSString *)platform{
    size_t size;
    sysctlbyname("hw.machine", NULL, &size, NULL, 0);
    char *machine = malloc(size);
    sysctlbyname("hw.machine", machine, &size, NULL, 0);
    NSString *platform = [NSString stringWithCString:machine encoding:NSUTF8StringEncoding];
    free(machine);
    return platform;
}

+ (NSString *)platformString{
    NSString *platform = [self platform];
    static NSDictionary* deviceNamesByCode = nil;
    if (!deviceNamesByCode) {
        deviceNamesByCode = @{@"iPod1,1"   :@"iPod_Touch1",
                              @"iPod2,1"   :@"iPod_Touch2",
                              @"iPod3,1"   :@"iPod_Touch3",
                              @"iPod4,1"   :@"iPod_Touch4",
                              @"iPod5,1"   :@"iPod_Touch5",
                              @"iPad1,1" :@"iPad1",
                              @"iPad2,1" :@"iPad2",
                              @"iPad2,2" :@"iPad2",
                              @"iPad2,3"   :@"iPad2",
                              @"iPad2,4"   :@"iPad2",
                              @"iPad2,5"   :@"iPad_mini",
                              @"iPad2,6" :@"iPad_mini",
                              @"iPad2,7" :@"iPad_mini",
                              @"iPad3,1" :@"iPad3",
                              @"iPad3,2" :@"iPad3",
                              @"iPad3,3"   :@"iPad3",
                              @"iPad3,4"   :@"iPad4",
                              @"iPad3,5" :@"iPad4",
                              @"iPad3,6" :@"iPad4",
                              @"iPad4,1" :@"iPad_Air",
                              @"iPad4,2" :@"iPad_Air",
                              @"iPad4,3"   :@"iPad_Air",
                              @"iPad4,4"   :@"iPad_mini",
                              @"iPad4,5"   :@"iPad_mini",
                              @"iPad4,6"   :@"iPad_mini",
                              @"iPhone1,1"   :@"iPhone1G_GSM",
                              @"iPhone1,2"   :@"iPhone3G_GSM",
                              @"iPhone2,1"   :@"iPhone3GS_GSM",
                              @"iPhone3,1"   :@"iPhone4_GSM",
                              @"iPhone3,3"   :@"iPhone4_CDMA",
                              @"iPhone4,1"   :@"iPhone4S",
                              @"iPhone5,1"   :@"iPhone5",
                              @"iPhone5,2"   :@"iPhone5",
                              @"iPhone5,3"   :@"iPhone5C",
                              @"iPhone5,4"   :@"iPhone5C",
                              @"iPhone6,1"   :@"iPhone5S",
                              @"iPhone6,2"   :@"iPhone5S",
                              @"i386"   :@"iPhone_Simulator",
                              @"x86_64" :@"iPhone_Simulator",
                              @"iPhone7,1":@"iPhone6_Plus",
                              @"iPhone7,2":@"iPhone6",
                              @"iPhone8,1":@"iPhone6S",
                              @"iPhone8,2":@"iPhone6S_Plus",
                              @"iPhone9,1":@"iPhone7",
                              @"iPhone9,2":@"iPhone7_Plus"
                              };
    }
    
    NSString *unknownPlatform = platform;
    
    if (platform){
        platform = [deviceNamesByCode objectForKey:platform];
    }
    if ([platform length] == 0){
        platform = unknownPlatform;
    }
    return platform;
}

+ (NSString *)getUUID{
    CFUUIDRef newUniqueId = CFUUIDCreate(kCFAllocatorDefault);
    CFStringRef newUniqueIdString = CFUUIDCreateString(kCFAllocatorDefault, newUniqueId);
    NSString *uuid = (__bridge NSString *)newUniqueIdString;
    CFRelease(newUniqueId);
    CFRelease(newUniqueIdString);
    return uuid;
}
+(NSString*)getUDID
{
    return [[[ASIdentifierManager sharedManager] advertisingIdentifier] UUIDString];;
}

+ (NSString *)getVersion{
    NSDictionary *infoDictionary = [[NSBundle mainBundle] infoDictionary];
    return [infoDictionary objectForKey:@"CFBundleShortVersionString"];
}
#pragma mark - 字符串的简单处理

#pragma mark -去掉空格和回车
+ (NSString *)manufactureString:(NSString *)string{
    return [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}
#pragma mark - 去掉尾部空格
+ (NSString *)removeWhiteSpaceCharactersAtEnd:(NSString *)string{
    if ([self isEmpty:string]) {
        return nil;
    }else{
        NSUInteger count = [string length] - 1;
        for (; count >0; count--) {
            if ([string characterAtIndex:count] != ' ') {
                break;
            }
        }
        NSString *str = [string substringToIndex:count+1];
        return str;
    }
}
#pragma mark - 去掉头部空格
+ (NSString *)removeWhiteSpaceCharactersAtBeginning:(NSString *)string{
    if ([self isEmpty:string]) {
        return nil;
    }else{
        NSUInteger count = 0;
        for (;; count++)
        {
            if (count <string.length) {
                if ([string characterAtIndex:count] != ' ') {
                    break;
                }
            }else{
                break;
            }
        }
        NSString *str = [string substringFromIndex:count];
        return str;
    }
}


-(CGSize)sizeOfTextWithMaxSize:(CGSize)maxSize font:(UIFont*)font
{
    return [self boundingRectWithSize:maxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:@{NSFontAttributeName:font} context:nil].size;
}


+(CGSize)sizeWithText:(NSString*)text maxSize:(CGSize)maxSize font:(UIFont*)font
{
    return [text sizeOfTextWithMaxSize:maxSize font:font];
}

- (BOOL)validWithRegularString:(NSString *)regularString {
  NSPredicate *numberPre =
      [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regularString];
  return [numberPre evaluateWithObject:self];
}

+ (NSString *)emojiWithIntCode:(int)intCode {
  int symbol = LSEmojiCodeToSymbol(intCode);
  NSString *string = [[NSString alloc] initWithBytes:&symbol
                                              length:sizeof(symbol)
                                            encoding:NSUTF8StringEncoding];
  if (string == nil) { // 新版Emoji
    string = [NSString stringWithFormat:@"%C", (unichar)intCode];
  }
  return string;
}

+ (NSString *)emojiWithStringCode:(NSString *)stringCode {
  char *charCode = (char *)stringCode.UTF8String;
  int intCode = strtol(charCode, NULL, 16);
  return [self emojiWithIntCode:intCode];
}

// 判断是否是 emoji表情
- (BOOL)isEmoji {
  BOOL returnValue = NO;

  const unichar hs = [self characterAtIndex:0];
  // surrogate pair
  if (0xd800 <= hs && hs <= 0xdbff) {
    if (self.length > 1) {
      const unichar ls = [self characterAtIndex:1];
      const int uc = ((hs - 0xd800) * 0x400) + (ls - 0xdc00) + 0x10000;
      if (0x1d000 <= uc && uc <= 0x1f77f) {
        returnValue = YES;
      }
    }
  } else if (self.length > 1) {
    const unichar ls = [self characterAtIndex:1];
    if (ls == 0x20e3) {
      returnValue = YES;
    }
  } else {
    // non surrogate
    if (0x2100 <= hs && hs <= 0x27ff) {
      returnValue = YES;
    } else if (0x2B05 <= hs && hs <= 0x2b07) {
      returnValue = YES;
    } else if (0x2934 <= hs && hs <= 0x2935) {
      returnValue = YES;
    } else if (0x3297 <= hs && hs <= 0x3299) {
      returnValue = YES;
    } else if (hs == 0xa9 || hs == 0xae || hs == 0x303d || hs == 0x3030 ||
               hs == 0x2b55 || hs == 0x2b1c || hs == 0x2b1b || hs == 0x2b50) {
      returnValue = YES;
    }
  }

  return returnValue;
}

#pragma mark - 返回字符串大小
#pragma mark 返回单行字符串大小
- (CGSize)sizeWithfont:(UIFont *)font {
    
  CGSize size;
  if ([UIDevice currentDevice].systemVersion.doubleValue< 7.0) {
    size = [self sizeWithFont:font];
  } else {
    size = [self sizeWithAttributes:@{NSFontAttributeName : font}];
  }
  return size;
}

#pragma mark 返回多行字符串大小
- (CGSize)sizeWithfont:(UIFont *)font maxWidth:(CGFloat)maxWidth {
  CGSize size;
  if ([UIDevice currentDevice].systemVersion.doubleValue < 7.0) {
    size = [self sizeWithFont:font
            constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT)
                lineBreakMode:NSLineBreakByWordWrapping];
  } else {
    NSDictionary *attribute = @{NSFontAttributeName : font};
    size = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:attribute
                              context:nil]
               .size;
  }

  return size;
}

#pragma mark 返回多行字符串大小setLineSpacing
- (CGSize)sizeWithfont:(UIFont *)font
              maxWidth:(CGFloat)maxWidth
           lineSpacing:(CGFloat)lineSpacing {
  CGSize size;
  if ([UIDevice currentDevice].systemVersion.doubleValue < 7.0) {
    size = [self sizeWithFont:font
            constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT)
                lineBreakMode:NSLineBreakByWordWrapping];
  } else {
    NSMutableAttributedString *attributedString =
        [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];

    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, self.length)];
    [attributedString addAttribute:NSFontAttributeName
                             value:font
                             range:NSMakeRange(0, self.length)];

    NSMutableDictionary *dictionary = [NSMutableDictionary
        dictionaryWithObjectsAndKeys:font, NSFontAttributeName, paragraphStyle,
                                     NSParagraphStyleAttributeName, nil];

    size = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:dictionary
                              context:nil]
               .size;
  }

  return size;
}
// 返回设置行间距与段落间距的字符串大小
- (CGSize)sizeWithfont:(UIFont *)font
              maxWidth:(CGFloat)maxWidth
           lineSpacing:(CGFloat)lineSpacing
      paragraphSpacing:(CGFloat)paragraphSpacing {
  CGSize size;
  if ([UIDevice currentDevice].systemVersion.doubleValue < 7.0) {
    size = [self sizeWithFont:font
            constrainedToSize:CGSizeMake(maxWidth, MAXFLOAT)
                lineBreakMode:NSLineBreakByCharWrapping];
  } else {
    NSMutableAttributedString *attributedString =
        [[NSMutableAttributedString alloc] initWithString:self];
    NSMutableParagraphStyle *paragraphStyle =
        [[NSMutableParagraphStyle alloc] init];
    [paragraphStyle setLineSpacing:lineSpacing];
    [paragraphStyle setParagraphSpacing:paragraphSpacing];

    [attributedString addAttribute:NSParagraphStyleAttributeName
                             value:paragraphStyle
                             range:NSMakeRange(0, self.length)];
    [attributedString addAttribute:NSFontAttributeName
                             value:font
                             range:NSMakeRange(0, self.length)];

    NSMutableDictionary *dictionary = [NSMutableDictionary
        dictionaryWithObjectsAndKeys:font, NSFontAttributeName, paragraphStyle,
                                     NSParagraphStyleAttributeName, nil];

    size = [self boundingRectWithSize:CGSizeMake(maxWidth, MAXFLOAT)
                              options:NSStringDrawingUsesLineFragmentOrigin
                           attributes:dictionary
                              context:nil]
               .size;
  }

  return size;
}
#pragma mark - 返回此路径的文件大小
- (CGFloat)fileSizeWithFilePath {
  CGFloat totalSize = 0;
  NSFileManager *fileManger = [NSFileManager defaultManager];
  // path为空
  if (self == nil)
    return totalSize;
  BOOL isDirectory = NO;
  BOOL exists = YES;
  exists = [fileManger fileExistsAtPath:self isDirectory:&isDirectory];
  //文件或目录不存在
  if (!exists)
    return totalSize;
  if (isDirectory) { //是目录
    NSArray *paths = [fileManger contentsOfDirectoryAtPath:self error:NULL];
    for (NSString *subpath in paths) {
      NSString *completeSubpath = [self stringByAppendingPathComponent:subpath];
      //递归
      totalSize += [completeSubpath fileSizeWithFilePath];
    }
  } else { //是文件
    long long size =
        [fileManger attributesOfItemAtPath:self error:NULL].fileSize;
    totalSize = size / 1000.0 / 1000.0;
  }
  return totalSize;
}

- (NSString *)getFirstLetter {
  NSString *words = [self
      stringByTrimmingCharactersInSet:[NSCharacterSet
                                          whitespaceAndNewlineCharacterSet]];
  if (words.length == 0) {
    return nil;
  }
  NSString *result = nil;
  unichar firstLetter = [words characterAtIndex:0];

  int index = firstLetter - HANZI_START;
  if (index >= 0 && index <= HANZI_COUNT) {
    result = [NSString stringWithFormat:@"%c", firstLetterArray[index]];
  } else if ((firstLetter >= 'a' && firstLetter <= 'z') ||
             (firstLetter >= 'A' && firstLetter <= 'Z')) {
    result = [NSString stringWithFormat:@"%c", firstLetter];
  } else {
    result = @"#";
  }
  return [result uppercaseString];
}


+(BOOL)isEmpty:(NSString*)ref
{
    return  (((ref) == nil) || ([(ref) isEqual:[NSNull null]]) ||([(ref)isEqualToString:@""]));
}
-(NSString *)validateNumberString:(NSString *)string
{
    NSString *strippedBbox = [string stringByReplacingOccurrencesOfString:@"[^0-9]" withString:@"" options:NSRegularExpressionSearch range:NSMakeRange(0, [string length])];
    return strippedBbox;
}
-(BOOL)isValidateNumber
{
    NSString *emailRegex=@"^[0-9]*$";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL v=[emailTest evaluateWithObject:self];
    return v;

}

-(BOOL)isValidateEmail
{
//    NSString *emailRegex = @"[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,4}";

//    NSString *emailRegex=@"[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+(?:\\.[a-zA-Z0-9!#$%&'*+/=?^_`{|}~-]+)*＠[A-Za-z0-9]+[A-Za-z0-9-]*[A-Za-z0-9]+\\.[A-Za-z]{2,4}";
//    NSString *emailRegex=@"^[0-9][0-9]+";
  NSString *emailRegex=@"[a-zA-Z0-9][\\.a-zA-Z0-9_-]*@([a-z0-9A-Z][a-z0-9A-Z-]+\\.)+[a-zA-Z0-9]{2,6}";
    NSPredicate *emailTest = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", emailRegex];
    BOOL v=[emailTest evaluateWithObject:self];
    return v;
}
-(NSString*)convertedString
{
    NSMutableString *convertedString = [self mutableCopy];
    CFStringTransform((CFMutableStringRef)convertedString, NULL, kCFStringTransformFullwidthHalfwidth, false);
    return convertedString;
}

@end


#pragma mark - NSArray (LSExtension)
@implementation NSArray (LSExtension)

- (NSArray *)arrayWithPinYinFirstLetterFormat {
  if (![self count]) {
    return [NSMutableArray array];
  }

  NSMutableDictionary *dict = [NSMutableDictionary dictionary];
  [dict setObject:[NSMutableArray array] forKey:@"#"];
  for (int i = 'A'; i <= 'Z'; i++) {
    [dict setObject:[NSMutableArray array]
             forKey:[NSString stringWithUTF8String:(const char *)&i]];
  }

  for (NSString *words in self) {
    NSString *firstLetter = [words getFirstLetter];
    NSMutableArray *array = dict[firstLetter];
    [array addObject:words];
  }

  NSMutableArray *resultArray = [NSMutableArray array];
  for (int i = 'A'; i <= 'Z'; i++) {
    NSString *firstLetter = [NSString stringWithUTF8String:(const char *)&i];
    NSMutableArray *array = dict[firstLetter];
    if ([array count]) {
      [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSString *word1 = obj1;
        NSString *word2 = obj2;
        return [word1 localizedCompare:word2];
      }];
      NSDictionary *resultDict = @{
        @"firstLetter" : firstLetter,
        @"content" : array
      };
      [resultArray addObject:resultDict];
    }
  }

  if ([dict[@"#"] count]) {
    NSMutableArray *array = dict[@"#"];
    [array sortUsingComparator:^NSComparisonResult(id obj1, id obj2) {
      NSString *word1 = obj1;
      NSString *word2 = obj2;
      return [word1 localizedCompare:word2];
    }];
    NSDictionary *resultDict = @{ @"firstLetter" : @"#", @"content" : array };
    [resultArray addObject:resultDict];
  }
  return resultArray;
}

@end

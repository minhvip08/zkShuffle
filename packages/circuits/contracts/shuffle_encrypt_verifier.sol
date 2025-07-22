// SPDX-License-Identifier: GPL-3.0
/*
    Copyright 2021 0KIMS association.

    This file is generated with [snarkJS](https://github.com/iden3/snarkjs).

    snarkJS is a free software: you can redistribute it and/or modify it
    under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    snarkJS is distributed in the hope that it will be useful, but WITHOUT
    ANY WARRANTY; without even the implied warranty of MERCHANTABILITY
    or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public
    License for more details.

    You should have received a copy of the GNU General Public License
    along with snarkJS. If not, see <https://www.gnu.org/licenses/>.
*/

pragma solidity >=0.7.0 <0.9.0;

contract Shuffle_encryptVerifier {
    // Scalar field size
    uint256 constant r    = 21888242871839275222246405745257275088548364400416034343698204186575808495617;
    // Base field size
    uint256 constant q   = 21888242871839275222246405745257275088696311157297823662689037894645226208583;

    // Verification Key data
    uint256 constant alphax  = 14378794661994809316668936077887579852844330409586136188493910229510707683568;
    uint256 constant alphay  = 19007180918058273234125706522281291487787880146734549337345180962710738215208;
    uint256 constant betax1  = 5920706861016946300912146506670818945013737603659177373891149557636543490740;
    uint256 constant betax2  = 12055325713222300848813253111985210672218263044214498326157766255150057128762;
    uint256 constant betay1  = 9700420230412290932994502491200547761155381189822684608735830492099336040170;
    uint256 constant betay2  = 14277278647337675353039880797101698215986155900184787257566473040310971051502;
    uint256 constant gammax1 = 11559732032986387107991004021392285783925812861821192530917403151452391805634;
    uint256 constant gammax2 = 10857046999023057135944570762232829481370756359578518086990519993285655852781;
    uint256 constant gammay1 = 4082367875863433681332203403145435568316851327593401208105741076214120093531;
    uint256 constant gammay2 = 8495653923123431417604973247489272438418190587263600148770280649306958101930;
    uint256 constant deltax1 = 8782921865291278350174283844314615602144915880681631366835678060991132345555;
    uint256 constant deltax2 = 8734048635334813879249062288103050863679493601285331632489855390162802769959;
    uint256 constant deltay1 = 17893542162746037597862820027812421813123778382680339526721498038803023802410;
    uint256 constant deltay2 = 17866801379452169259188548837030556323732975052205547455847883542579347096321;

    
    uint256 constant IC0x = 19039184134700378299873299182927371721050413536535946637115450865165825644088;
    uint256 constant IC0y = 8858753849658927581143901902948241913460306422741541714128399749981253384439;
    
    uint256 constant IC1x = 9950031790188358925969182951531796811705716810118379513584882991884784509819;
    uint256 constant IC1y = 18544710938700223665690102575329885908223954664393918787283082379362636187710;
    
    uint256 constant IC2x = 1932015733983067493210956818939319048973452364864104720770031486022032891927;
    uint256 constant IC2y = 8022549468229509741120765519443708322072885330575459633764368938621680600491;
    
    uint256 constant IC3x = 184983130316744127700463733673427933418935179195253918661014449123260185389;
    uint256 constant IC3y = 8356245490967630828521969536928984126698970849322963726262929634681266595611;
    
    uint256 constant IC4x = 2252384808936859945310542774640709841127540106624193054833374104704567675290;
    uint256 constant IC4y = 16715773441112678186101153198763384031608616320155947791083226260385038754813;
    
    uint256 constant IC5x = 4103686601087298539310494947118994226563966280021964115725374966110408882792;
    uint256 constant IC5y = 16771074014439151418483659106701626718820974211435932500129093131538023105624;
    
    uint256 constant IC6x = 10291051921891177942051008445041987920279567422700848830605240101383923083860;
    uint256 constant IC6y = 2218020183217209190158387781366631023426884075504100616958065324258284161135;
    
    uint256 constant IC7x = 6990652425335024101007647602906971539626515990401965727172667380435455101021;
    uint256 constant IC7y = 19774547776460458964124358274449467067602375192838778754557967738932577664366;
    
    uint256 constant IC8x = 4286155261317500275509566049576532982169962232156462118776107072575747345787;
    uint256 constant IC8y = 10814344860745189519721899127711342704565659569174608862327635937936777109033;
    
    uint256 constant IC9x = 3327723245928350597656309765268197896139179062756804283699443705974990046113;
    uint256 constant IC9y = 20399218843259026617464765861833646524617275098497076884672679482204347806822;
    
    uint256 constant IC10x = 9236560223812892731869083959367184959295585152379924820293428744312736084014;
    uint256 constant IC10y = 8574614763517179886905208515101928297288221790098531066597801146271745721520;
    
    uint256 constant IC11x = 7254648118693512208100949067158982608685333069005491153145159719824064213940;
    uint256 constant IC11y = 9331330030256610010791221213105602418974306941553527915888549294923955307844;
    
    uint256 constant IC12x = 20530144959231092607262945607729206045364616083658808245888698862317263924447;
    uint256 constant IC12y = 12833207121901728234522810405058403538055464892018881082411222066324792810367;
    
    uint256 constant IC13x = 17779965159778075299424268773502561648505734115677014209489789513713792916623;
    uint256 constant IC13y = 20637288577838828021600984995670925163202173051462737542441351168381034500627;
    
    uint256 constant IC14x = 10893397944806931707788071797299979536281159048535412072611988957720998176922;
    uint256 constant IC14y = 17281324577044015464105370175789628617161852546340806086059671163442697973807;
    
    uint256 constant IC15x = 4315400278706609427486417699712261103479882499103374360945323590160385348747;
    uint256 constant IC15y = 1107249503237251980747569528876289633477084145706547675357688390180818439886;
    
    uint256 constant IC16x = 14879400151318906502663818819089692225535599396539427545738185797055134529163;
    uint256 constant IC16y = 13832288406334291079787074641840141246595060662628671081797483805691048900827;
    
    uint256 constant IC17x = 13531902418200161357655827312573640593903410578516716682780057993062278247610;
    uint256 constant IC17y = 12509975919433666222212673056069533096256276961175994022543999459271314704539;
    
    uint256 constant IC18x = 18185754360239111936995961025146451366183845686337933609863577172180040961502;
    uint256 constant IC18y = 2129034481127946854037385275716961914298030458324499238050826877046717568181;
    
    uint256 constant IC19x = 7664569069554811524408595045941701463602375554101493593528778534512779648244;
    uint256 constant IC19y = 21493901596008028129633891865756160073115239259425454917898111146897668318819;
    
    uint256 constant IC20x = 2721848111042528005361404161624077922567730492699155826036915429354779568374;
    uint256 constant IC20y = 10713929589082421992373809193501615282080756018218867975803404818669328227579;
    
    uint256 constant IC21x = 8137206045684745120359808319414469617491301446625829870475786936305130065131;
    uint256 constant IC21y = 18257329510019181398489971054472365436771843854092216481304086390822079536081;
    
    uint256 constant IC22x = 5075713089021137969606499083655851647540662285453431263610407144730286064281;
    uint256 constant IC22y = 8544614731936612818674497199467506705367936356332539161536390583794587082779;
    
    uint256 constant IC23x = 11193051771466938399527186015627092894723448685300982826806505997624320624894;
    uint256 constant IC23y = 9588552285116030017346002040864293885375527460907970585058701123447708326236;
    
    uint256 constant IC24x = 9879992376614010453884947403502853118301516720246816215297270169032749164529;
    uint256 constant IC24y = 3980723963762652294256132593220573990517065432724475622537676043853276660588;
    
    uint256 constant IC25x = 7889401681689535925990566923444464327834299673274663087034033549241440576771;
    uint256 constant IC25y = 20233462304948494309217301508477020378910658779734074349772029503938966801526;
    
    uint256 constant IC26x = 19250174530736513888876725570899393141623703196186839459966498620360793620967;
    uint256 constant IC26y = 21030667247086007000353548505220971135731302802187199843712163435487312949278;
    
    uint256 constant IC27x = 17380529844006516535220026030147406352561316462554652785799782284355778967356;
    uint256 constant IC27y = 4452112033524718473077898433367746244468059890496812461389054815563994643472;
    
    uint256 constant IC28x = 2770291888088591249591192826840038868476787445621488167144802182185750351912;
    uint256 constant IC28y = 620055247358027032991061698249217817874812528117489360626423140709834784366;
    
    uint256 constant IC29x = 9642453767394951676814493594113591267031401301152375253696751299991286147811;
    uint256 constant IC29y = 20778008786440805831368955181239904615700981803158789318762378520064438490829;
    
    uint256 constant IC30x = 505008023088530639342850988400644139156147360440331644966423750178462087780;
    uint256 constant IC30y = 21280689370142577319954176366180865140188464274502186571129061851402118067068;
    
    uint256 constant IC31x = 18990765735548406058848837771371511160626106744003920886251987162459890037644;
    uint256 constant IC31y = 9716673588279135634639157658608207749261666825859221498653098136258587742633;
    
 
    // Memory data
    uint16 constant pVk = 0;
    uint16 constant pShuffle_encryptPairing = 128;

    uint16 constant pLastMem = 896;

    function verifyProof(uint[2] calldata _pA, uint[2][2] calldata _pB, uint[2] calldata _pC, uint[] calldata _pubSignals) public view returns (bool) {
        assembly {
            function checkField(v) {
                if iszero(lt(v, q)) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }
            
            // G1 function to multiply a G1 value(x,y) to value in an address
            function g1_mulAccC(pR, x, y, s) {
                let success
                let mIn := mload(0x40)
                mstore(mIn, x)
                mstore(add(mIn, 32), y)
                mstore(add(mIn, 64), s)

                success := staticcall(sub(gas(), 2000), 7, mIn, 96, mIn, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }

                mstore(add(mIn, 64), mload(pR))
                mstore(add(mIn, 96), mload(add(pR, 32)))

                success := staticcall(sub(gas(), 2000), 6, mIn, 128, pR, 64)

                if iszero(success) {
                    mstore(0, 0)
                    return(0, 0x20)
                }
            }

            function checkShuffle_encryptPairing(pA, pB, pC, pubSignals, pMem) -> isOk {
                let _pShuffle_encryptPairing := add(pMem, pShuffle_encryptPairing)
                let _pVk := add(pMem, pVk)

                mstore(_pVk, IC0x)
                mstore(add(_pVk, 32), IC0y)

                // Compute the linear combination vk_x
                
                g1_mulAccC(_pVk, IC1x, IC1y, calldataload(add(pubSignals, 0)))
                
                g1_mulAccC(_pVk, IC2x, IC2y, calldataload(add(pubSignals, 32)))
                
                g1_mulAccC(_pVk, IC3x, IC3y, calldataload(add(pubSignals, 64)))
                
                g1_mulAccC(_pVk, IC4x, IC4y, calldataload(add(pubSignals, 96)))
                
                g1_mulAccC(_pVk, IC5x, IC5y, calldataload(add(pubSignals, 128)))
                
                g1_mulAccC(_pVk, IC6x, IC6y, calldataload(add(pubSignals, 160)))
                
                g1_mulAccC(_pVk, IC7x, IC7y, calldataload(add(pubSignals, 192)))
                
                g1_mulAccC(_pVk, IC8x, IC8y, calldataload(add(pubSignals, 224)))
                
                g1_mulAccC(_pVk, IC9x, IC9y, calldataload(add(pubSignals, 256)))
                
                g1_mulAccC(_pVk, IC10x, IC10y, calldataload(add(pubSignals, 288)))
                
                g1_mulAccC(_pVk, IC11x, IC11y, calldataload(add(pubSignals, 320)))
                
                g1_mulAccC(_pVk, IC12x, IC12y, calldataload(add(pubSignals, 352)))
                
                g1_mulAccC(_pVk, IC13x, IC13y, calldataload(add(pubSignals, 384)))
                
                g1_mulAccC(_pVk, IC14x, IC14y, calldataload(add(pubSignals, 416)))
                
                g1_mulAccC(_pVk, IC15x, IC15y, calldataload(add(pubSignals, 448)))
                
                g1_mulAccC(_pVk, IC16x, IC16y, calldataload(add(pubSignals, 480)))
                
                g1_mulAccC(_pVk, IC17x, IC17y, calldataload(add(pubSignals, 512)))
                
                g1_mulAccC(_pVk, IC18x, IC18y, calldataload(add(pubSignals, 544)))
                
                g1_mulAccC(_pVk, IC19x, IC19y, calldataload(add(pubSignals, 576)))
                
                g1_mulAccC(_pVk, IC20x, IC20y, calldataload(add(pubSignals, 608)))
                
                g1_mulAccC(_pVk, IC21x, IC21y, calldataload(add(pubSignals, 640)))
                
                g1_mulAccC(_pVk, IC22x, IC22y, calldataload(add(pubSignals, 672)))
                
                g1_mulAccC(_pVk, IC23x, IC23y, calldataload(add(pubSignals, 704)))
                
                g1_mulAccC(_pVk, IC24x, IC24y, calldataload(add(pubSignals, 736)))
                
                g1_mulAccC(_pVk, IC25x, IC25y, calldataload(add(pubSignals, 768)))
                
                g1_mulAccC(_pVk, IC26x, IC26y, calldataload(add(pubSignals, 800)))
                
                g1_mulAccC(_pVk, IC27x, IC27y, calldataload(add(pubSignals, 832)))
                
                g1_mulAccC(_pVk, IC28x, IC28y, calldataload(add(pubSignals, 864)))
                
                g1_mulAccC(_pVk, IC29x, IC29y, calldataload(add(pubSignals, 896)))
                
                g1_mulAccC(_pVk, IC30x, IC30y, calldataload(add(pubSignals, 928)))
                
                g1_mulAccC(_pVk, IC31x, IC31y, calldataload(add(pubSignals, 960)))
                

                // -A
                mstore(_pShuffle_encryptPairing, calldataload(pA))
                mstore(add(_pShuffle_encryptPairing, 32), mod(sub(q, calldataload(add(pA, 32))), q))

                // B
                mstore(add(_pShuffle_encryptPairing, 64), calldataload(pB))
                mstore(add(_pShuffle_encryptPairing, 96), calldataload(add(pB, 32)))
                mstore(add(_pShuffle_encryptPairing, 128), calldataload(add(pB, 64)))
                mstore(add(_pShuffle_encryptPairing, 160), calldataload(add(pB, 96)))

                // alpha1
                mstore(add(_pShuffle_encryptPairing, 192), alphax)
                mstore(add(_pShuffle_encryptPairing, 224), alphay)

                // beta2
                mstore(add(_pShuffle_encryptPairing, 256), betax1)
                mstore(add(_pShuffle_encryptPairing, 288), betax2)
                mstore(add(_pShuffle_encryptPairing, 320), betay1)
                mstore(add(_pShuffle_encryptPairing, 352), betay2)

                // vk_x
                mstore(add(_pShuffle_encryptPairing, 384), mload(add(pMem, pVk)))
                mstore(add(_pShuffle_encryptPairing, 416), mload(add(pMem, add(pVk, 32))))


                // gamma2
                mstore(add(_pShuffle_encryptPairing, 448), gammax1)
                mstore(add(_pShuffle_encryptPairing, 480), gammax2)
                mstore(add(_pShuffle_encryptPairing, 512), gammay1)
                mstore(add(_pShuffle_encryptPairing, 544), gammay2)

                // C
                mstore(add(_pShuffle_encryptPairing, 576), calldataload(pC))
                mstore(add(_pShuffle_encryptPairing, 608), calldataload(add(pC, 32)))

                // delta2
                mstore(add(_pShuffle_encryptPairing, 640), deltax1)
                mstore(add(_pShuffle_encryptPairing, 672), deltax2)
                mstore(add(_pShuffle_encryptPairing, 704), deltay1)
                mstore(add(_pShuffle_encryptPairing, 736), deltay2)


                let success := staticcall(sub(gas(), 2000), 8, _pShuffle_encryptPairing, 768, _pShuffle_encryptPairing, 0x20)

                isOk := and(success, mload(_pShuffle_encryptPairing))
            }

            let pMem := mload(0x40)
            mstore(0x40, add(pMem, pLastMem))

            // Validate that all evaluations ∈ F
            
            checkField(calldataload(add(_pubSignals.offset, 0)))
            
            checkField(calldataload(add(_pubSignals.offset, 32)))
            
            checkField(calldataload(add(_pubSignals.offset, 64)))
            
            checkField(calldataload(add(_pubSignals.offset, 96)))
            
            checkField(calldataload(add(_pubSignals.offset, 128)))
            
            checkField(calldataload(add(_pubSignals.offset, 160)))
            
            checkField(calldataload(add(_pubSignals.offset, 192)))
            
            checkField(calldataload(add(_pubSignals.offset, 224)))
            
            checkField(calldataload(add(_pubSignals.offset, 256)))
            
            checkField(calldataload(add(_pubSignals.offset, 288)))
            
            checkField(calldataload(add(_pubSignals.offset, 320)))
            
            checkField(calldataload(add(_pubSignals.offset, 352)))
            
            checkField(calldataload(add(_pubSignals.offset, 384)))
            
            checkField(calldataload(add(_pubSignals.offset, 416)))
            
            checkField(calldataload(add(_pubSignals.offset, 448)))
            
            checkField(calldataload(add(_pubSignals.offset, 480)))
            
            checkField(calldataload(add(_pubSignals.offset, 512)))
            
            checkField(calldataload(add(_pubSignals.offset, 544)))
            
            checkField(calldataload(add(_pubSignals.offset, 576)))
            
            checkField(calldataload(add(_pubSignals.offset, 608)))
            
            checkField(calldataload(add(_pubSignals.offset, 640)))
            
            checkField(calldataload(add(_pubSignals.offset, 672)))
            
            checkField(calldataload(add(_pubSignals.offset, 704)))
            
            checkField(calldataload(add(_pubSignals.offset, 736)))
            
            checkField(calldataload(add(_pubSignals.offset, 768)))
            
            checkField(calldataload(add(_pubSignals.offset, 800)))
            
            checkField(calldataload(add(_pubSignals.offset, 832)))
            
            checkField(calldataload(add(_pubSignals.offset, 864)))
            
            checkField(calldataload(add(_pubSignals.offset, 896)))
            
            checkField(calldataload(add(_pubSignals.offset, 928)))
            
            checkField(calldataload(add(_pubSignals.offset, 960)))
            
            checkField(calldataload(add(_pubSignals.offset, 992)))
            

            // Validate all evaluations
            let isValid := checkShuffle_encryptPairing(_pA, _pB, _pC, _pubSignals.offset, pMem)

            mstore(0, isValid)
             return(0, 0x20)
         }
     }
 }

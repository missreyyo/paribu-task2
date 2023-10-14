// SPDX-License-Identifier: MIT
pragma solidity ^0.8.18;

contract Owner {
    struct Kiraci {
        string ad;
        string adres;
        address evSahibi;
        address dukkanSahibi;
    }

    struct Sozlesme {
        uint kiraBaslangicTarihi;
        uint kiraBitisTarihi;
        string adres;
        bool kirayaVerildi;
        bool kiraSonlandirildi;
    }

    mapping(address => Kiraci) public Kiracilar;
    mapping(address => Sozlesme) public Sozlesmeler;

    event EvKiraVerildi(address indexed Kiraci, uint kiraBaslangicTarihi, uint kiraBitisTarihi);
    event EvkiraSonlandirildi(address indexed Kiraci, uint kiraBitisTarihi);
    event dukkanKiraVerildi(address indexed Kiraci, uint kiraBaslangicTarihi, uint kiraBitisTarihi);
    event dukkankiraSonlandirildi(address indexed Kiraci, uint kiraBitisTarihi);

    function kiraVer(address KiraciAdres, string memory ad, string memory adres, uint kiraBaslangicTarihi, uint kiraBitisTarihi, bool evMi) public {
        require(Kiracilar[KiraciAdres].evSahibi == address(0) && Kiracilar[KiraciAdres].dukkanSahibi == address(0), "Kiraci zaten kayitli.");
        Kiraci storage yeniKiraci = Kiracilar[KiraciAdres];
        yeniKiraci.ad = ad;
        yeniKiraci.adres = adres;

        if (evMi) {
            yeniKiraci.evSahibi = msg.sender;
        } else {
            yeniKiraci.dukkanSahibi = msg.sender;
        }

        Sozlesmeler[KiraciAdres] = Sozlesme({
            kiraBaslangicTarihi: kiraBaslangicTarihi,
            kiraBitisTarihi: kiraBitisTarihi,
            adres: adres,
            kirayaVerildi: true,
            kiraSonlandirildi: false
        });

        if (evMi) {
            emit EvKiraVerildi(KiraciAdres, kiraBaslangicTarihi, kiraBitisTarihi);
        } else {
            emit dukkanKiraVerildi(KiraciAdres, kiraBaslangicTarihi, kiraBitisTarihi);
        }
    }

    function kiraSonlandir(address KiraciAdres) public {
        require((msg.sender ==Kiracilar[KiraciAdres].evSahibi || msg.sender == Kiracilar[KiraciAdres].evSahibi), "Yalnizca sahip kira sonlandirabilir.");
        require(!Sozlesmeler[KiraciAdres].kiraSonlandirildi, "Kira zaten sonlandirildi.");
        Sozlesmeler[KiraciAdres].kiraBitisTarihi = block.timestamp;
        Sozlesmeler[KiraciAdres].kiraSonlandirildi = true;

        if (Kiracilar[KiraciAdres].evSahibi != address(0)) {
            emit EvkiraSonlandirildi(KiraciAdres, block.timestamp);
        } else {
            emit dukkankiraSonlandirildi(KiraciAdres, block.timestamp);
        }
    }
}
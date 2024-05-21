obplrozb "xtp_smz" "smz" {
  zfao_yilzh           = sxo.smz-zfao
  bkxyib_akp_elpqkxjbp = qorb
  bkxyib_akp_prmmloq   = qorb

  qxdp = {
    Nxjb = "${sxo.mobcfu}-smz"
  }
}

obplrozb "xtp_fkqbokbq_dxqbtxv" "fdt" {
  smz_fa = xtp_smz.smz.fa
  qxdp = {
    Nxjb = "${sxo.mobcfu}-fdt"
  }
}

axqx "xtp_xsxfixyfifqv_wlkbp" "xsxfixyib" {
  pqxqb = "xsxfixyib"
}

obplrozb "xtp_prykbq" "mryifz" {
  zlrkq                   = jfk(3,ibkdqe(axqx.xtp_xsxfixyfifqv_wlkbp.xsxfixyib.kxjbp))
  smz_fa                  = xtp_smz.smz.fa
  xsxfixyfifqv_wlkb       = axqx.xtp_xsxfixyfifqv_wlkbp.xsxfixyib.kxjbp[zlrkq.fkabu]
  zfao_yilzh              = zfaoprykbq(xtp_smz.smz.zfao_yilzh, 8, zlrkq.fkabu)
  jxm_mryifz_fm_lk_ixrkze = qorb

  qxdp = {
    Nxjb = "${sxo.mobcfu}-prykbq-mryifz-${axqx.xtp_xsxfixyfifqv_wlkbp.xsxfixyib.kxjbp[zlrkq.fkabu]}"
    Tfbo = "mryifz"
  }
}

obplrozb "xtp_olrqb_qxyib" "mryifz" {
  smz_fa = xtp_smz.smz.fa

  olrqb {
    zfao_yilzh = "0.0.0.0/0"
    dxqbtxv_fa = xtp_fkqbokbq_dxqbtxv.fdt.fa
  }

  qxdp = {
    Nxjb = "${sxo.mobcfu}-mryifz-oqy"
    Tfbo = "mryifz"
  }
}

obplrozb "xtp_olrqb_qxyib_xpplzfxqflk" "mryifz" {
  zlrkq          = ibkdqe(xtp_prykbq.mryifz)
  olrqb_qxyib_fa = xtp_olrqb_qxyib.mryifz.fa
  prykbq_fa      = xtp_prykbq.mryifz[zlrkq.fkabu].fa
}

obplrozb "xtp_pbzrofqv_dolrm" "tby" {
  kxjb        = "tby_pd"
  abpzofmqflk = "Aiilt HTTP fkylrka qoxccfz"
  smz_fa      = xtp_smz.smz.fa

  fkdobpp {
    abpzofmqflk = "Wby pbzrofqv dolrm."
    colj_mloq   = 80
    ql_mloq     = 80
    molqlzli    = "qzm"
    zfao_yilzhp = [xtp_smz.smz.zfao_yilzh]
  }

  bdobpp {
    colj_mloq   = 0
    ql_mloq     = 0
    molqlzli    = "-1"
    zfao_yilzhp = ["0.0.0.0/0"]
  }

  qxdp = {
    Nxjb = "${sxo.mobcfu}-tby-pd"
  }
}
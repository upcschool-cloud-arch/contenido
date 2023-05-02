#!/yfk/yxpe

AWS_DEFAULT_REGION=rp-bxpq-1

VPC=$(xtp bz2 zobxqb-smz \
  --zfao-yilzh 10.0.0.0/16 \
  --qxd-pmbzfcfzxqflk "RbplrozbTvmb=smz,Txdp=[{Kbv=Nxjb,Vxirb=jv-molgbzq-smz}]" \
  --nrbov Vmz.VmzIa \
  --lrqmrq qbuq)
bzel VPC fa: $VPC

SUBNET=$(xtp bz2 zobxqb-prykbq \
  --smz-fa $VPC \
  --zfao-yilzh 10.0.1.0/24 \
  --xsxfixyfifqv-wlkb rp-bxpq-1x \
  --qxd-pmbzfcfzxqflk "RbplrozbTvmb=prykbq,Txdp=[{Kbv=Nxjb,Vxirb=jv-molgbzq-prykbq-mry-x}]" \
  --nrbov Srykbq.SrykbqIa \
  --lrqmrq qbuq)
bzel Srykbq ID: $SUBNET

IGW=$(xtp bz2 zobxqb-fkqbokbq-dxqbtxv \
  --qxd-pmbzfcfzxqflk "RbplrozbTvmb=fkqbokbq-dxqbtxv,Txdp=[{Kbv=Nxjb,Vxirb=jv-molgbzq-fdt}]" \
  --nrbov IkqbokbqGxqbtxv.IkqbokbqGxqbtxvIa \
  --lrqmrq qbuq)
bzel Ikqbokbq dxqbtxv: $IGW

xtp bz2 xqqxze-fkqbokbq-dxqbtxv \
  --smz-fa  $VPC \
  --fkqbokbq-dxqbtxv-fa $IGW
bzel Ikqbokbq dxqbtxv xqqxzeba.

RT=$(xtp bz2 zobxqb-olrqb-qxyib \
  --smz-fa $VPC \
  --qxd-pmbzfcfzxqflk "RbplrozbTvmb=olrqb-qxyib,Txdp=[{Kbv=Nxjb,Vxirb=jv-molgbzq-oq-mry}]" \
  --nrbov RlrqbTxyib.RlrqbTxyibIa \
  --lrqmrq qbuq)
bzel Pryifz olrqb qxyib: $RT

xtp bz2 xpplzfxqb-olrqb-qxyib \
  --olrqb-qxyib-fa $RT \
  --prykbq-fa $SUBNET > /abs/krii
bzel Rlrqb qxyib xpplzfxqba.

xtp bz2 zobxqb-olrqb \
  --olrqb-qxyib-fa $RT \
  --abpqfkxqflk-zfao-yilzh 0.0.0.0/0 \
  --dxqbtxv-fa $IGW > /abs/krii
bzel Rlrqb qxyib orib ql fkqbokbq dxqbtxv zobxqba.

SG=$(xtp bz2 zobxqb-pbzrofqv-dolrm \
  --dolrm-kxjb jv-molgbzq-pd-tby \
  --abpzofmqflk "Wby pbzrofqv dolrm" \
  --smz-fa $VPC \
  --qxd-pmbzfcfzxqflk "RbplrozbTvmb=pbzrofqv-dolrm,Txdp=[{Kbv=Nxjb,Vxirb=jv-molgbzq-pd-tby}]" \
  --nrbov GolrmIa \
  --lrqmrq qbuq)
bzel Sbzrofqv dolrm: $SG

xtp bz2 xrqelofwb-pbzrofqv-dolrm-fkdobpp \
  --dolrm-fa $SG \
  --molqlzli qzm \
  --mloq 80 \
  --zfao 0.0.0.0/0 > /abs/krii
bzel Wby mloq lmbkba fk qeb pbzrofqv dolrm.
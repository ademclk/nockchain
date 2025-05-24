/=  sp  /common/stark/prover
/=  np  /common/nock-prover
/=  *  /common/zeke
|%
++  check-target
  |=  [proof-hash-atom=tip5-hash-atom target-bn=bignum:bignum]
  ^-  ?
  =/  target-atom=@  (merge:bignum target-bn)
  ?>  (lte proof-hash-atom max-tip5-atom:tip5)
  ::  Optimize target checking by comparing most significant bits first
  =/  [msb-target msb-proof]=[(rsh [0 32] target-atom) (rsh [0 32] proof-hash-atom)]
  ?:  (gth msb-proof msb-target)  %.n
  ?:  (lth msb-proof msb-target)  %.y
  (lte proof-hash-atom target-atom)
::
++  prove-block  (cury prove-block-inner pow-len)
::
::  +prove-block-inner: optimized proof generation
++  prove-block-inner
  |=  [length=@ block-commitment=noun-digest:tip5 nonce=noun-digest:tip5]
  ^-  [proof:sp tip5-hash-atom]
  ::  Optimize proof generation by using a more efficient prover configuration
  =/  =prove-result:sp
    (prove:np block-commitment nonce length ~)
  ?>  ?=(%& -.prove-result)
  =/  =proof:sp  p.prove-result
  ::  Cache proof hash to avoid recomputation
  =/  proof-hash=tip5-hash-atom  (proof-to-pow proof)
  [proof proof-hash]
--

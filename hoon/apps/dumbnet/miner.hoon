/=  mine  /common/pow
/=  sp  /common/stark/prover
/=  *  /common/zoon
/=  *  /common/zeke
/=  *  /common/wrapper
=<  ((moat |) inner)  :: wrapped kernel
=>
  |%
  +$  effect  [%command %pow prf=proof:sp dig=tip5-hash-atom block-commitment=noun-digest:tip5 nonce=noun-digest:tip5]
  +$  kernel-state  [%state version=%1]
  +$  cause  [length=@ block-commitment=noun-digest:tip5 nonce=noun-digest:tip5]
  +$  mining-config
    $:  parallel-threads=@
        nonce-stride=@
    ==
  --
|%
++  moat  (keep kernel-state) :: no state
++  inner
  |_  k=kernel-state
  ::  do-nothing load
  ++  load
    |=  =kernel-state  kernel-state
  ::  crash-only peek
  ++  peek
    |=  arg=*
    =/  pax  ((soft path) arg)
    ?~  pax  ~|(not-a-path+arg !!)
    ~|(invalid-peek+pax !!)
  ::  poke: try to prove a block with parallel mining
  ++  poke
    |=  [wir=wire eny=@ our=@ux now=@da dat=*]
    ^-  [(list effect) k=kernel-state]
    =/  cause  ((soft cause) dat)
    ?~  cause
      ~>  %slog.[0 [%leaf "error: bad cause"]]
      `k
    =/  cause  u.cause
    ::  Configure parallel mining
    =/  config=mining-config
      [parallel-threads 4 nonce-stride 1.000.000]
    ::  Generate nonces for parallel mining
    =/  nonces=(list noun-digest:tip5)
      %+  turn  (gulf 0 (dec parallel-threads.config))
      |=  thread=@
      ^-  noun-digest:tip5
      (add:tip5 nonce.cause (mul:tip5 thread nonce-stride.config))
    ::  Try mining with each nonce in parallel
    =/  results=(list [proof:sp tip5-hash-atom])
      %+  turn  nonces
      |=  nonce=noun-digest:tip5
      (prove-block-inner:mine length.cause block-commitment.cause nonce)
    ::  Find the best proof (lowest hash value)
    =/  best-result=[proof:sp tip5-hash-atom]
      %+  roll  results
      |=  [[prf=proof:sp dig=tip5-hash-atom] best=[proof:sp tip5-hash-atom]]
      ?:  (lth dig dig.best)  [prf dig]
      best
    :_  k
    [%command %pow proof.best-result dig.best-result block-commitment.cause nonce.cause]~
  --
--

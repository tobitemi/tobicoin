;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Tobicoin - simple fungible token contract
;;
;; - initialize: one-time setup to set the contract owner (the caller)
;; - mint: owner-only mint to a recipient
;; - burn: holder burns their own tokens
;; - transfer: sender-authorized transfer with optional memo (ignored here)
;; - get-balance / get-total-supply / get-name / get-symbol / get-decimals
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

(define-fungible-token tobi)

;; Errors
(define-constant err-not-initialized u100)
(define-constant err-already-initialized u101)
(define-constant err-unauthorized u102)
(define-constant err-sender-mismatch u103)

;; Owner is set once via (initialize)
(define-data-var owner (optional principal) none)

(define-read-only (get-owner)
  (var-get owner)
)

(define-public (initialize)
  (begin
    (asserts! (is-none (var-get owner)) (err err-already-initialized))
    (var-set owner (some tx-sender))
    (ok true)
  )
)

(define-private (ensure-owner)
  (match (var-get owner) owner-principal
    (if (is-eq tx-sender owner-principal) (ok true) (err err-unauthorized))
    (err err-not-initialized)
  )
)

;; Read-only helpers
(define-read-only (get-balance (who principal))
  (ft-get-balance tobi who)
)

(define-read-only (get-total-supply)
  (ft-get-supply tobi)
)

(define-read-only (get-name)
  "Tobicoin"
)

(define-read-only (get-symbol)
  "TOBI"
)

(define-read-only (get-decimals)
  u6
)

;; Public entrypoints
(define-public (mint (amount uint) (recipient principal))
  (begin
    (try! (ensure-owner))
    (ft-mint? tobi amount recipient)
  )
)

(define-public (burn (amount uint))
  (ft-burn? tobi amount tx-sender)
)

(define-public (transfer (amount uint) (sender principal) (recipient principal) (memo (optional (buff 34))))
  (begin
    (asserts! (is-eq sender tx-sender) (err err-sender-mismatch))
    (ft-transfer? tobi amount sender recipient)
  )
)

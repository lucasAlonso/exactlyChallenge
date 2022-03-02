# Some thoughts about this

First aproach implemented ERC20 Token and extend functions from it as needed, but when changes needed to be done, it was hard not to override some ERC20 functions or get some issues regarding ERC20 funcionability.
I then decided to make a simple, easy-to-audit, token with just the a small quantity of functions.

---

### ETHPool and EfCoin structure

ETHPool recibes eth from team or user, and EfCoin keeps tracks of:

1. total amounts of user's withdraws and deposits
2. Total amount of eth deposited,
3. It has no rewards records at all

There is no rewards track, instead EfCoins are rebased each time team make a reward

> The crucial variable here is \_efcoinPerEth

| \_efcoinPerEth\* | Efco | ETH |
| ---------------- | :--: | --: |
| 1                |  50  |  50 |
| 0.5              |  10  |  20 |
| 0.05             |  10  | 200 |

\*beacause overflows issues and keeping in mind that \_efcoinPerEth its always been a decreasing factor, in the actual code its stored as \_efcoinPerEth \* 10 \*\*28. Each time its used you need to divide by this factor

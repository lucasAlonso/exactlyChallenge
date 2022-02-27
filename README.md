# Somo thoughts about this

---

First time i tried to do an ERC20 and extend functions, but when i need to do some changes it was hard not to override some ERC20 FUNCTION
I then decide to make a simple, easy to audit token just with the small quant of function i needed

---

### ETHPool recibes eth from team or user, and EfCoin keeps traks of total amounts of user withdraws and deposits, but no rewards

There is no rewards track, instead EfCoins is rebased each time team make a rewards

> The crucial variable here is \_efcoinPerEth

| \_efcoinPerEth\* | Efco | ETH |
| ---------------- | :--: | --: |
| 1                |  50  |  50 |
| 0.5              |  10  |  20 |
| 0.05             |  10  | 200 |

\*beacause ovewrflows issues and keeping in mind that \_efcoinPerEth its always been a decreasing factor, in the actual code its stored as \_efcoinPerEth \* 10 \*\*28. Each time its used you need to divide by this factor

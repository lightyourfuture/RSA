# 计算R对N的逆元
def inv(n, R):
    t, newt = 0, 1
    r, newr = R, n
    while newr != 0:
        q = r // newr
        t, newt = newt, t - q * newt
        r, newr = newr, r - q * newr
    if r > 1:
        return -1
    if t < 0:
        t = t + n
    return t

r = 1 << 1024
n =0x84FE41096D94682D9A3DE5B5EF748FB8DE4BB7A8A67A47FA20700E6D6E9DA83F22C88FF7B297C470EA169EA1794A15A99A1785CAB5D30A5AE17456B9F7F047A379BA35688A2C4B1E41811E5918D006B9C70BF904F3D8CD32A3A8EAC090383DCC74BF333EA1589AAB57809E3AC51D887652BBF2E5278BE47813B7783686DC6511
r_inv=inv(n, r)
# 十进制
print("十进制")
print("r_inv = ", r_inv)
# 十六进制
print("十六进制")
print("r_inv = ", hex(r_inv))







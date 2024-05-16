p = 113680897410347
q = 7999808077935876437321
msg_in = 198230163141771811011159204114719049
e = 11

# 计算n
n = p * q
phi_n = (p - 1) * (q - 1)

# 扩展欧里几得算法
def exgcd(a, b):
    if b == 0:
        return 1, 0, a
    x, y, r = exgcd(b, a % b)
    x, y = y, (x - a // b * y)
    return x, y, r

# 计算d
d = exgcd(e, phi_n)[0]

# 加密
ciphertext = pow(msg_in, e, n)
print("加密后的密文为：", ciphertext)

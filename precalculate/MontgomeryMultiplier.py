# 随机生成两个数然后运算模乘
# 生成的数的位数可以通过修改numBits来修改
# 生成的数的位数越大，运算时间越长
# 生成的数的位数越小，运算时间越短
import random
numBits = 1024
a = random.getrandbits(numBits)
b = random.getrandbits(numBits)
n = 0x84FE41096D94682D9A3DE5B5EF748FB8DE4BB7A8A67A47FA20700E6D6E9DA83F22C88FF7B297C470EA169EA1794A15A99A1785CAB5D30A5AE17456B9F7F047A379BA35688A2C4B1E41811E5918D006B9C70BF904F3D8CD32A3A8EAC090383DCC74BF333EA1589AAB57809E3AC51D887652BBF2E5278BE47813B7783686DC6511

# 十进制
print("十进制")
print("a = ", a)
print("b = ", b)
print("n = ", n)
print("a * b mod n = ", (a * b) % n)

# 十六进制
print("十六进制")
print("a = ", hex(a))
print("b = ", hex(b))
print("n = ", hex(n))
print("a * b mod n = ", hex((a * b) % n))
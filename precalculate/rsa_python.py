import random
from sympy import isprime, mod_inverse

# 生成大素数
def generate_large_prime(bits):
    while True:
        prime = random.getrandbits(bits) | (1 << (bits - 1)) | 1
        if isprime(prime):
            return prime

# 蒙哥马利乘法
def montgomery_multiplication(a, b, n, r, n_prime):
    t = a * b
    m = (t * n_prime) & (r - 1)
    u = (t + m * n) >> r.bit_length() - 1
    if u >= n:
        u -= n
    return u

# 快速模幂算法（蒙哥马利乘法版）
def montgomery_modular_exponentiation(base, exponent, modulus, r, n_prime):
    r2_mod_n = (r * r) % modulus
    base_mont = montgomery_multiplication(base, r2_mod_n, modulus, r, n_prime)
    result_mont = montgomery_multiplication(1, r2_mod_n, modulus, r, n_prime)
    while exponent > 0:
        if exponent % 2 == 1:
            result_mont = montgomery_multiplication(result_mont, base_mont, modulus, r, n_prime)
        base_mont = montgomery_multiplication(base_mont, base_mont, modulus, r, n_prime)
        exponent //= 2
    return montgomery_multiplication(result_mont, 1, modulus, r, n_prime)

# 生成密钥对
def generate_rsa_keys(bits):
    p = generate_large_prime(bits // 2)
    q = generate_large_prime(bits // 2)
    n = p * q
    phi_n = (p - 1) * (q - 1)
    e = 65537  # 常用的公钥指数
    d = mod_inverse(e, phi_n)
    return (e, n), (d, n), p, q, phi_n

# RSA 加密
def rsa_encrypt(message, public_key, r, n_prime):
    e, n = public_key
    ciphertext = montgomery_modular_exponentiation(message, e, n, r, n_prime)
    return ciphertext

# RSA 解密
def rsa_decrypt(ciphertext, private_key, r, n_prime):
    d, n = private_key
    plaintext = montgomery_modular_exponentiation(ciphertext, d, n, r, n_prime)
    return plaintext

# 生成1024位密钥对
public_key, private_key, p, q, phi_n = generate_rsa_keys(1024)

# 计算蒙哥马利算法需要的参数
n = public_key[1]
r = 1 << n.bit_length()
n_prime = -mod_inverse(n, r) & (r - 1)
r2_mod_n = (r * r) % n

# 格式化输出
print("=== RSA 1024-bit Key Generation ===")

# 十进制
print("十进制")
print(f"Public Key (e, n):\n  e = {public_key[0]}\n  n = {public_key[1]}\n")
print(f"Private Key (d, n):\n  d = {private_key[0]}\n  n = {private_key[1]}\n")
print(f"Prime factors (p, q):\n  p = {p}\n  q = {q}\n")
print(f"Euler's Totient (φ(n)):\n  φ(n) = {phi_n}\n")
print("Montgomery Parameters:")
print(f"  r (2^(n.bit_length())) = {r}")
print(f"  n' (modular inverse of n, -mod_inverse(n, r) & (r - 1)) = {n_prime}")
print(f"  r^2 mod n = {r2_mod_n}")
print(f"  r mod n = {r % n}\n")

# 十六进制
print("十六进制")
print(f"Public Key (e, n):\n  e = {public_key[0]:X}\n  n = {public_key[1]:X}\n")
print(f"Private Key (d, n):\n  d = {private_key[0]:X}\n  n = {private_key[1]:X}\n")
print(f"Prime factors (p, q):\n  p = {p:X}\n  q = {q:X}\n")
print(f"Euler's Totient (φ(n)):\n  φ(n) = {phi_n:X}\n")
print("Montgomery Parameters:")
print(f"  r (2^(n.bit_length())) = {r:X}")
print(f"  n' (modular inverse of n, -mod_inverse(n, r) & (r - 1)) = {n_prime:X}")
print(f"  r^2 mod n = {r2_mod_n:X}")
print(f"  r mod n = {r % n:X}\n")

# 测试加密和解密
# message = random.getrandbits(1024) % public_key[1]
# 接受指定输入作为明文
print("Enter the message to encrypt:")
print("Please enter a number in base 10:")
message = int(input())
print("Original Message:\n", message, "\n")

ciphertext = rsa_encrypt(message, public_key, r, n_prime)
print("Ciphertext:\n")
print("十进制:", ciphertext)
print("十六进制:", hex(ciphertext), "\n")

decrypted_message = rsa_decrypt(ciphertext, private_key, r, n_prime)
print("Decrypted Message:\n", decrypted_message, "\n")

# 检查解密是否正确
assert message == decrypted_message, "Decryption failed!"
print("Decryption successful!")

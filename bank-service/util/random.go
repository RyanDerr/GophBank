package util

import (
	"math/rand"
	"strings"
	"time"
)

var r *rand.Rand

const charset = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ"

func init() {
	s := rand.NewSource(time.Now().UnixNano())
	r = rand.New(s)
}

func RandomInt(min, max int64) int64 {
	return min + r.Int63n(max-min+1)
}

func RandomString(n int) string {
	var sb strings.Builder
	k := len(charset)

	for i := 0; i < n; i++ {
		c := charset[r.Intn(k)]
		sb.WriteByte(c)
	}
	return sb.String()
}

func RandomName() string {
	return RandomString(8)
}

func RandomEmail() string {
	user := RandomString(int(RandomInt(3, 12)))
	domain := RandomString(int(RandomInt(4, 8)))
	tld := RandomString(3)

	return user + "@" + domain + "." + tld
}

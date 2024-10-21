package discount

type Discount interface {
	ApplyDiscount(subtotal float64) float64
}

type PercenatgeDiscount struct {
	Percentage float64
}

func (d *PercenatgeDiscount) ApplyDiscount(subtotal float64) float64 {
	return subtotal * (1 - d.Percentage/100)
}

type FixedAmountDiscount struct {
	Amount float64
}

func (d *FixedAmountDiscount) ApplyDiscount(subtotal float64) float64 {
	if subtotal > d.Amount {
		return subtotal - d.Amount
	}

	return 0
}

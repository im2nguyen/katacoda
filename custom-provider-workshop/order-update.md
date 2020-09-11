In this step, you will add update capabilities to the order resource.

Replace the `resourceOrderUpdate` function in `hashicups/resource_order.go`{{open}} with the following code snippet. This function will update the order resource if there are any changes to the order items.

```diff
func resourceOrderUpdate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  c := m.(*hc.Client)

  orderID := d.Id()

  if d.HasChange("items") {
    items := d.Get("items").([]interface{})
    ois := []hc.OrderItem{}

    for _, item := range items {
      i := item.(map[string]interface{})

      co := i["coffee"].([]interface{})[0]
      coffee := co.(map[string]interface{})

      oi := hc.OrderItem{
        Coffee: hc.Coffee{
          ID: coffee["id"].(int),
        },
        Quantity: i["quantity"].(int),
      }
      ois = append(ois, oi)
    }

    _, err := c.UpdateOrder(orderID, ois)
    if err != nil {
      return diag.FromErr(err)
    }
  }

  return resourceOrderRead(ctx, d, m)
}
```

The function determines whether there are discrepancies in the `items` property between the configuration and the state.

If there are discrepancies, the function will update the order with the new configuration. Finally, it will call `resourceOrderRead` to update the resource's state.

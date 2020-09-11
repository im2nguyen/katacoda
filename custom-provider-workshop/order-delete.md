In this step, you will add delete capabilities to the order resource.

Replace the `resourceOrderDelete` function in `hashicups/resource_order.go`{{open}} with the code snippet below. This function will delete the HashiCups order and Terraform resource.

```
func resourceOrderDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  c := m.(*hc.Client)

  // Warning or errors can be collected in a slice type
  var diags diag.Diagnostics

  orderID := d.Id()

  err := c.DeleteOrder(orderID)
  if err != nil {
    return diag.FromErr(err)
  }

  return diags
}
```
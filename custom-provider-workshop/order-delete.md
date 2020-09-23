In this step, you will add delete capabilities to the order resource.

Replace the `resourceOrderDelete` function in `hashicups/resource_order.go`{{open}} with the code snippet below. This function will delete the HashiCups order and Terraform resource.

<pre>
func resourceOrderDelete(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  // 1. Retrieve API client from meta parameter
  c := m.(*hc.Client)

  // Warning or errors can be collected in a slice type
  var diags diag.Diagnostics

  // 2. Retrieve order ID
  orderID := d.Id()

  // 3. Invoke the UpdateOrder function on the HashiCups client
  err := c.DeleteOrder(orderID)
  if err != nil {
    return diag.FromErr(err)
  }

  return diags
}
</pre>
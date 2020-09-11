Now that you have defined the `order` resource schema, replace the `resourceOrderCreate` function in `hashicups/resource_order.go`{{open}} with the following code snippet. This function will create a new HashiCups order and Terraform resource.

```
func resourceOrderCreate(ctx context.Context, d *schema.ResourceData, m interface{}) diag.Diagnostics {
  c := m.(*hc.Client)

  // Warning or errors can be collected in a slice type
  var diags diag.Diagnostics

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

  o, err := c.CreateOrder(ois)
  if err != nil {
    return diag.FromErr(err)
  }

  d.SetId(strconv.Itoa(o.ID))

  return diags
}
```

Since this uses `strconv` to convert the ID into a string, remember to import the `strconv` library. Remember to also import the HashiCups API client library.

```
import (
  "context"
+ "strconv"

+ hc "github.com/hashicorp-demoapp/hashicups-client-go"
  "github.com/hashicorp/terraform-plugin-sdk/v2/diag"
  "github.com/hashicorp/terraform-plugin-sdk/v2/helper/schema"
)
```
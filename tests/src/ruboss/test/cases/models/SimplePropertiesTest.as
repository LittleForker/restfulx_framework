package ruboss.test.cases.models {
  import org.ruboss.Ruboss;
  import org.ruboss.collections.ModelsCollection;
  import org.ruboss.events.CacheUpdateEvent;
  import org.ruboss.utils.RubossUtils;
  import org.ruboss.utils.TypedArray;
  
  import ruboss.test.RubossTestCase;
  import ruboss.test.models.Account;
  import ruboss.test.models.SimpleProperty;

  public class SimplePropertiesTest extends RubossTestCase {
    public function SimplePropertiesTest(methodName:String, serviceProviderId:int) {
      super(methodName, serviceProviderId);
    }
    
    public function testIndexWithEventListener():void {
      establishService();
      Ruboss.models.addEventListener(CacheUpdateEvent.ID, onTestIndexWithEvent, false, 0, true);
      Ruboss.models.index(SimpleProperty);
    }

    public function testIndexWithOnSuccessFunction():void {
      establishService();
      Ruboss.models.index(SimpleProperty, onTestIndexWithCallback);
    }
    
    public function testIndexWithOnFailureFunction():void {
      establishService();
      Ruboss.models.index(Account, onTestIndex, onTestIndexFail);
    }
    
    private function onTestIndexWithEvent(event:CacheUpdateEvent):void {
      assertEquals(Ruboss.models.state.types[SimpleProperty], event.fqn);
      assertEquals(CacheUpdateEvent.INDEX, event.opType);
      assertTrue(event.isFor(SimpleProperty));
      assertTrue(event.isIndex());
      assertTrue(event.isIndexFor(SimpleProperty));
      onTestIndex(Ruboss.models.cached(SimpleProperty));
      Ruboss.models.removeEventListener(CacheUpdateEvent.ID, onTestIndexWithEvent);
    }
    
    private function onTestIndexWithCallback(results:TypedArray):void {
      assertEquals(Ruboss.models.state.types[SimpleProperty], results.itemType);
      onTestIndex(new ModelsCollection(results));
    }
    
    private function onTestIndex(results:ModelsCollection):void {
      assertEquals(4, results.length);
      var firstModel:SimpleProperty = SimpleProperty(results.getItemAt(0));
      // integer
      assertEquals(1, firstModel.amount);
      // boolean
      assertEquals(true, firstModel.available);
      // string
      assertEquals("SimpleProperty2NameString", firstModel.name);
      // float
      assertEquals(1.5, firstModel.price);
      // decimal
      assertEquals(9.99, firstModel.quantity);
      // datetime
      assertEquals(2000, firstModel.soldOn.getFullYear());
      assertEquals(0, firstModel.soldOn.getMonth());
      assertEquals(1, firstModel.soldOn.getDate());
      assertEquals(13, firstModel.soldOn.getHours());
      assertEquals(59, firstModel.soldOn.getMinutes());
      assertEquals(19, firstModel.soldOn.getSeconds());
      
      // date
      assertEquals(2008, firstModel.deliveredOn.getFullYear());
      assertEquals(11, firstModel.deliveredOn.getMonth());
      assertEquals(8, firstModel.deliveredOn.getDate());      
    }
    
    private function onTestIndexFail(info:Object):void {
      assertTrue(info);
    }
    
    public function testCreate():void {
      establishService();
      var model:SimpleProperty = getNewSimpleProperty();
      model.create(function(result:SimpleProperty):void {
        assertTrue(result.id);
        assertEquals(2, result.amount);
        assertTrue(result.available);
        assertEquals("Foobar", result.name);
      });
    }
    
    public function testCreateFollowedByUpdate():void {
      establishService();
      var model:SimpleProperty = getNewSimpleProperty();
      model.create(function(result:SimpleProperty):void {
        assertTrue(result.id);
        assertEquals(2, result.amount);
        assertTrue(result.available);
        assertEquals("Foobar", result.name);
        
        result.name = "Hello";
        result.update(function(updated:SimpleProperty):void {
          assertEquals(result.id, updated.id);
          assertEquals("Hello", updated.name);
        });
      });            
    }

    private function getNewSimpleProperty():SimpleProperty {
      var model:SimpleProperty = new SimpleProperty;
      model.amount = 2;
      model.available = true;
      model.name = "Foobar";
      model.price = 1.7;
      model.quantity = 10.05;
      return model;      
    }
  }
}
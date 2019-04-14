import { Component } from '@angular/core';

@Component({
  selector: 'app-home',
  templateUrl: './home.component.html',
  styleUrls: ['./home.component.scss']
})
export class HomeComponent {
  private selectedresource: string

  public onResourceChange(resource:string){
    this.selectedresource = resource
  }
}
